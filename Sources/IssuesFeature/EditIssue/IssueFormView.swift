import Entities
import SharedUI
import SwiftUI

struct IssueFormView: View {
  @Binding var issue: GithubIssue

  var body: some View {
    VStack(spacing: .Spacing.S) {
      TextField(
        String(localized: "title_placeholder", bundle: .module),
        text: $issue.title,
        axis: .vertical
      )
      .lineLimit(4)
      .font(.Style.h1)
      .foregroundColor(.Style.primary)

      TextField(
        String(localized: "body_placeholder", bundle: .module),
        text: .init(
          get: { issue.body ?? "" },
          set: { issue.body = $0 }
        ),
        axis: .vertical
      )
      .lineLimit(6...12)
      .font(.Style.body)
      .foregroundColor(.Style.text)
    }
    .textFieldStyle(.roundedBorder)
  }
}

#Preview {
  IssueFormView(
    issue: .constant(
      .init(
        id: 0, number: 0, state: .open, title: "hola", body: "", labels: [], comments: 2,
        createdAt: .now, updatedAt: .now)))
}
