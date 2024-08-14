import Dependencies
import Entities
import Foundation
import MarkdownUI
import Repository
import SharedUI
import SwiftNavigation
import SwiftUI

func formatRelativeUpdate(date: Date) -> String {
  let formatter = RelativeDateTimeFormatter()
  return formatter.localizedString(for: date, relativeTo: .now)
}

public struct IssuesView: View {
  @State var viewModel: IssuesViewModel

  public init() {
    self.viewModel = .init()
  }

  public var body: some View {
    Group {
      if viewModel.isLoading {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        if let $issues = Binding($viewModel.issues) {
          if $issues.isEmpty {
            EmptyScreenView()
          } else {
            List {
              ForEach($issues, id: \.self) { $issue in
                Button {
                  viewModel.tapped(issue: .init(binding: $issue))
                } label: {
                  row(for: issue)
                }
                .buttonStyle(.plain)
              }
              .listRowBackground(Color.Style.background2)
              .listRowSeparator(.automatic)
            }
            .scrollContentBackground(.hidden)
          }
        }
      }
    }
    .background {
      Color.Style.background.ignoresSafeArea()
    }
    .errorScreen(
      error: $viewModel.error,
      retry: {
        try await viewModel.getIssues()
      }
    )
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          viewModel.tappedNewButton()
        } label: {
          Image(systemName: "plus")
            .bold()
        }
      }
    }
    .navigationDestination(
      item: $viewModel.destination.issue
    ) { issue in
      withDependencies(from: viewModel) {
        IssueDetailView(issue: issue)
      }
    }
    .sheet(item: $viewModel.destination.new) { completion in
      NavigationStack {
        withDependencies(from: viewModel) {
          CreateIssueView(completion: { completion.run(()) })
        }
      }
    }
    .task {
      if viewModel.issues == nil {
        try? await viewModel.getIssues()
      }
    }
    .navigationTitle(Text("issues_nav_title", bundle: .module))
  }

  @ViewBuilder
  func row(for issue: GithubIssue) -> some View {
    VStack(alignment: .leading, spacing: .Spacing.XS) {
      Text(issue.title)
        .h2()

      issueSubtitle(issue: issue)

      HStack {
        Text("number_\(issue.comments)_comments", bundle: .module)
          .body()
          .italic()

        Spacer()

        GithubIssueStateView(state: issue.state)
      }
    }
    .multilineTextAlignment(.leading)
  }

  private func issueSubtitle(issue: GithubIssue) -> some View {
    var locString = String(
      localized:
        "issue_number_\(issue.number)_created_time_ago_\(formatRelativeUpdate(date: issue.createdAt))",
      bundle: .module)

    if let user = issue.user?.login {
      locString.append(
        String(localized: "by_user_\(user)", bundle: .module)
      )
    }

    return Markdown(locString).styled()
  }
}

#Preview {
  NavigationStack {
    withDependencies {
      SharedUI.registerFonts()
      SharedUI.setUpNavigationStyle()
      $0.githubRepo = .liveValue
    } operation: {
      IssuesView()
    }
  }
}
