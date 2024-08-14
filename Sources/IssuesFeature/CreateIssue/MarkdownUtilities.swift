import Entities
import Foundation

extension GithubIssue {
  func body(with files: [CreateGithubBranchFileResponse]) -> String {
    let body = body ?? ""
    if files.isEmpty {
      return body
    } else {
      return """
        \(body)

        ## Associated documents:
        \(files.map(\.markdownLink).joined(separator: "\n"))
        """
    }
  }
}

extension CreateGithubBranchFileResponse {
  var markdownLink: String {
    "- [\(content.name)](\(content.downloadUrl.absoluteString))"
  }
}
