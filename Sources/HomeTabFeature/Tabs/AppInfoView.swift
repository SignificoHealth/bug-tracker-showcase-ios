import Dependencies
import IssuesFeature
import MarkdownUI
import SharedUI
import SwiftUI

struct AppInfoView: View {
  @State var viewModel: AppInfoViewModel

  init() {
    self.viewModel = .init()
  }

  var body: some View {
    ScrollView {
      VStack(spacing: .Spacing.S) {
        if viewModel.isLoading {
          ProgressView()
        } else {
          if let user = viewModel.user {
            Text("app_name", bundle: .module)
              .display1()

            Text("logged_in_as_\(user.login)", bundle: .module)
              .body()

            Markdown(
              .init(localized: "app_description", bundle: .module)
            )
            .styled()

            Spacer()

            Button(
              action: viewModel.startButtonTapped,
              label: {
                Text("lets_start_button", bundle: .module)
                  .foregroundColor(.Style.primary)
                  .body()
                  .bold()
                  .padding(.horizontal)
              }
            )
            .tint(.Style.secondary)
            .buttonStyle(BorderedProminentButtonStyle())
          }
        }
      }
      .padding(.Spacing.M)
    }
    .errorScreen(
      error: $viewModel.error,
      retry: {
        try await viewModel.getGithubUser()
      }
    )
    .background {
      Color.Style.background.ignoresSafeArea()
    }
    .sheet(
      isPresented: Binding(
        $viewModel.destination.issues
      )
    ) {
      NavigationStack {
        IssuesView()
      }
    }
    .task {
      if viewModel.user == nil {
        try? await viewModel.getGithubUser()
      }
    }
  }
}

#Preview {
  VStack {
    let _ = registerFonts()
    AppInfoView()
  }
}
