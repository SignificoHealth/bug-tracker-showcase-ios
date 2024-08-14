import MarkdownUI
import SharedUI
import SwiftUI

struct AboutView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: .Spacing.M) {
        Text("about", bundle: .module)
          .display1()
          .frame(maxWidth: .infinity)

        Markdown(.init(localized: "about_text", bundle: .module))
          .styled()
      }
      .padding(.Spacing.M)
    }
    .background {
      Color.Style.background.ignoresSafeArea()
    }
  }
}

#Preview {
  VStack {
    AboutView()
      .environment(\.locale, .init(identifier: "de"))
  }
}
