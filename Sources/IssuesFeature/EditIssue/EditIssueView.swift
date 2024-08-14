import Entities
import SwiftUI

struct EditIssueView: View {
  @State var viewModel: EditIssueViewModel
  @Environment(\.dismiss) var dismiss

  init(issue: Referenced<GithubIssue>) {
    self.viewModel = .init(
      issue: issue.wrapped,
      editingCompleted: { issue.wrapped = $0 }
    )
  }

  var body: some View {
    VStack {
      Picker("", selection: $viewModel.tabSelection) {
        ForEach(EditIssueViewModel.TabSelection.allCases, id: \.self) { tab in
          Text(.init(stringLiteral: tab.rawValue), bundle: .module)
            .body()
        }
      }
      .pickerStyle(.segmented)
      .padding(.horizontal, .Spacing.S)

      TabView(selection: $viewModel.tabSelection) {
        editIssueView
          .tag(EditIssueViewModel.TabSelection.edit)

        previewIssue
          .tag(EditIssueViewModel.TabSelection.preview)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          if viewModel.isLoading {
            ProgressView()
          } else {
            Button {
              Task {
                try await saveAndDismiss()
              }
            } label: {
              Image(systemName: "paperplane.fill")
            }
            .disabled(viewModel.isInvalid)
          }
        }
      }
    }
    .errorScreen(
      error: $viewModel.error,
      retry: { try await saveAndDismiss() }
    )
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(Text("edit_issue_nav_title_\(viewModel.editingIssue.number)", bundle: .module))
    .padding(.vertical, .Spacing.XS)
    .background {
      Color.Style.background.ignoresSafeArea()
    }
  }

  private var editIssueView: some View {
    ScrollView {
      IssueFormView(issue: $viewModel.editingIssue)
        .padding(.Spacing.S)
    }
  }

  private var previewIssue: some View {
    ScrollView {
      PreviewIssueView(issue: viewModel.editingIssue)
        .padding(.Spacing.S)
    }
  }

  private func saveAndDismiss() async throws {
    try await viewModel.save()
    await MainActor.run {
      dismiss()
    }
  }
}
