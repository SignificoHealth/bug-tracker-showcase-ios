import Entities
import MarkdownUI
import SharedUI
import SwiftUI

struct PreviewIssueView: View {
  var issue: GithubIssue

  var body: some View {
    VStack(alignment: .leading, spacing: .Spacing.S) {
      GithubIssueStateView(state: issue.state)
        .frame(maxWidth: .infinity, alignment: .leading)

      (Text(issue.title)
        + Text("issue_number_\(issue.number)", bundle: .module))
        .h1()

      if let user = issue.user {
        Text(
          "user_\(user.login)_opened_issue \(formatRelativeUpdate(date: issue.createdAt))",
          bundle: .module
        )
        .body()
      } else {
        Text("opened_issue \(formatRelativeUpdate(date: issue.createdAt))", bundle: .module)
          .body()
      }

      if let body = issue.body {
        Markdown(body)
          .styled()
      }

      Text("number_\(issue.comments)_comments", bundle: .module)
        .body()
    }
  }
}

#Preview {
  PreviewIssueView(
    issue: .init(
      id: 0, number: 0, state: .open, title: "hola", body: "", labels: [], comments: 2,
      createdAt: .now, updatedAt: .now))
}
