import Dependencies
import Entities
import MarkdownUI
import SharedUI
import SwiftUI

struct IssueDetailView: View {
  @State var viewModel: IssueDetailViewModel

  init(issue: Referenced<GithubIssue>) {
    self.viewModel = .init(issue: issue)
  }

  private var issue: GithubIssue {
    viewModel.issue.wrapped
  }

  var body: some View {
    ScrollView {
      PreviewIssueView(issue: issue)
        .padding(.Spacing.M)
    }
    .background {
      Color.Style.background.ignoresSafeArea()
    }
    .navigationTitle(Text("issue_number_\(issue.number)_nav_title", bundle: .module))
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          viewModel.editTapped()
        } label: {
          Image(systemName: "square.and.pencil")
            .bold()
        }
      }
    }
    .navigationDestination(item: $viewModel.destination.editIssue) {
      issue in
      withDependencies(from: viewModel) {
        EditIssueView(issue: issue)
      }
    }
  }
}
