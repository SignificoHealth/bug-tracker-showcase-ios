import Foundation

public struct GithubBranchFile: Equatable {
  public init(
    name: String, path: String, sha: String, size: Int, url: URL, htmlUrl: URL, gitUrl: URL,
    downloadUrl: URL, type: String
  ) {
    self.name = name
    self.path = path
    self.sha = sha
    self.size = size
    self.url = url
    self.htmlUrl = htmlUrl
    self.gitUrl = gitUrl
    self.downloadUrl = downloadUrl
    self.type = type
  }

  public let name: String
  public let path: String
  public let sha: String
  public let size: Int
  public let url: URL
  public let htmlUrl: URL
  public let gitUrl: URL
  public let downloadUrl: URL
  public let type: String
}

public struct CreateGithubBranchFileResponse: Equatable {
  public init(content: GithubBranchFile) {
    self.content = content
  }

  public let content: GithubBranchFile
}

public struct CreateGithubBranchFileRequest: Equatable {
  public init(message: String, content: String, branch: String? = nil) {
    self.message = message
    self.content = content
    self.branch = branch
  }

  public let message: String
  public let content: String
  public let branch: String?
}
