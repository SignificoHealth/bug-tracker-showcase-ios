import MarkdownUI
import SharedUI
import SwiftUI

struct CreateIssueView: View {
  @State var viewModel: CreateIssueViewModel
  @Environment(\.dismiss) var dismiss

  init(completion: @escaping () -> Void) {
    viewModel = .init(completion: completion)
  }

  var body: some View {
    VStack {
      Picker("issue_tab_selection_label", selection: $viewModel.tabSelection) {
        ForEach(CreateIssueViewModel.TabSelection.allCases, id: \.self) { tab in
          Text(.init(stringLiteral: tab.rawValue), bundle: .module)
            .font(.Style.body)
        }
      }
      .pickerStyle(.segmented)
      .padding(.horizontal, .Spacing.M)

      TabView(selection: $viewModel.tabSelection) {
        editIssueView
          .tag(CreateIssueViewModel.TabSelection.edit)

        previewIssueView
          .tag(CreateIssueViewModel.TabSelection.preview)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          HStack(spacing: .Spacing.S) {
            if viewModel.fileLoading {
              ProgressView()
            } else {
              Button {
                viewModel.tappedOnAttachDocument()
              } label: {
                Image(systemName: "paperclip").bold()
              }
            }

            if viewModel.createLoading {
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
    }
    .errorScreen(
      error: $viewModel.sendError,
      retry: { try await saveAndDismiss() }
    )
    .errorScreen(
      error: $viewModel.fileError,
      retry: { try await viewModel.retryFileUpload() }
    )
    .fileImporter(
      isPresented: Binding($viewModel.destination.fileImporter),
      allowedContentTypes: [.pdf, .image],
      onCompletion: { result in
        if case let .success(url) = result {
          Task {
            try await viewModel.sendFile(url: url)
          }
        }
      }
    )
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(Text("new_issue_nav_title", bundle: .module))
    .padding(.vertical, .Spacing.S)
    .background {
      Color.Style.background.ignoresSafeArea()
    }
  }

  private var editIssueView: some View {
    ScrollView {
      VStack {
        IssueFormView(issue: $viewModel.newIssue)

        if !viewModel.attachedFiles.isEmpty {
          Markdown(
            """
            ## Associated documents:
            \(viewModel.attachedFiles.map(\.markdownLink).joined(separator: "\n"))
            """
          )
          .styled()
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      .padding(.Spacing.M)
    }
  }

  private var previewIssueView: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .Spacing.S) {
        if viewModel.newIssue.title.isEmpty {
          Text("new_issue_title_empty", bundle: .module)
            .h1()
        } else {
          Text(viewModel.newIssue.title)
            .h1()
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        Markdown(viewModel.newIssue.body(with: viewModel.attachedFiles))
          .styled()
      }
      .padding(.Spacing.M)
    }
  }

  private func saveAndDismiss() async throws {
    try await viewModel.tappedOnSave()
    await MainActor.run {
      dismiss()
    }
  }
}

#Preview {
  NavigationStack {
    CreateIssueView(completion: {})
  }
}
