import SwiftUI
import SwiftUINavigation

public struct ErrorScreenView<Content: View>: View {
  @Binding var isPresented: Bool
  @State private var isLoading: Bool = false

  var content: () -> Content
  var retry: (() async throws -> Void)?

  public init(
    isPresented: Binding<Bool>,
    retry: (() async throws -> Void)?,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self._isPresented = isPresented
    self.content = content
    self.retry = retry
  }

  public var body: some View {
    if isPresented {
      VStack(spacing: .Spacing.S) {
        Image(systemName: "icloud.slash.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 200, height: 200)
          .tint(.Style.primary)

        Text("generic_error", bundle: .module)
          .h2()
          .multilineTextAlignment(.center)

        if let retry = retry {
          if isLoading {
            ProgressView()
          } else {
            Button {
              Task {
                await MainActor.run { isLoading = true }
                do {
                  try await retry()
                  await MainActor.run {
                    isPresented = false
                  }
                } catch {
                  await MainActor.run {
                    isLoading = false
                  }
                }
              }
            } label: {
              Text("retry_button", bundle: .module)
                .foregroundColor(.Style.primary)
                .body()
                .bold()
                .padding(.horizontal, .Spacing.XXXS)
                .padding(.vertical, .Spacing.XXXS)

            }
            .buttonStyle(BorderedProminentButtonStyle())
            .tint(.Style.secondary)
          }
        }
      }
      .padding(.Spacing.S)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      content()
    }
  }
}

extension View {
  public func errorScreen(
    error: Binding<Error?>,
    retry: @escaping () async throws -> Void
  ) -> some View {
    ErrorScreenView(
      isPresented: Binding(error),
      retry: retry,
      content: {
        self
      }
    )
  }

  public func errorScreen(
    error: Binding<Error?>
  ) -> some View {
    ErrorScreenView(
      isPresented: Binding(error),
      retry: nil,
      content: {
        self
      }
    )
  }
}

#Preview {
  ErrorScreenView(
    isPresented: .constant(true),
    retry: {},
    content: { EmptyView() }
  )
}
