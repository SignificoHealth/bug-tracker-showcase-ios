import SwiftUI

public struct EmptyScreenView: View {
  public init() {}

  public var body: some View {
    VStack(spacing: .Spacing.S) {
      Image(systemName: "checkmark.circle.fill")
        .resizable()
        .frame(width: 200, height: 200)

      Text("empty_screen_title", bundle: .module)
        .h1()

      Text("empty_screen_description", bundle: .module)
        .body()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  EmptyScreenView()
}
