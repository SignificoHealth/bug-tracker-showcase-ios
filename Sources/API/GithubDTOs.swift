import Foundation

public struct IssueDTO: Codable {
  public init(
    id: Int, number: Int, state: IssueStateDTO, title: String, body: String? = nil,
    user: UserDTO? = nil, labels: [LabelDTO], assignee: UserDTO? = nil, assignees: [UserDTO]? = nil,
    comments: Int, closed_at: String? = nil, created_at: String, updated_at: String
  ) {
    self.id = id
    self.number = number
    self.state = state
    self.title = title
    self.body = body
    self.user = user
    self.labels = labels
    self.assignee = assignee
    self.assignees = assignees
    self.comments = comments
    self.closed_at = closed_at
    self.created_at = created_at
    self.updated_at = updated_at
  }

  public let id: Int
  public let number: Int
  public let state: IssueStateDTO
  public let title: String
  public let body: String?
  public let user: UserDTO?
  public let labels: [LabelDTO]
  public let assignee: UserDTO?
  public let assignees: [UserDTO]?
  public let comments: Int
  public let closed_at: String?
  public let created_at: String
  public let updated_at: String
}

public enum IssueStateDTO: String, Codable {
  case open
  case closed
}

public struct UserDTO: Codable {
  public init(id: Int, name: String? = nil, email: String? = nil, login: String, avatar_url: String)
  {
    self.id = id
    self.name = name
    self.email = email
    self.login = login
    self.avatar_url = avatar_url
  }

  public let id: Int
  public let name: String?
  public let email: String?
  public let login: String
  public let avatar_url: String
}

public struct LabelDTO: Codable {
  public init(id: Int, name: String, description: String? = nil, color: String) {
    self.id = id
    self.name = name
    self.description = description
    self.color = color
  }

  public let id: Int
  public let name: String
  public let description: String?
  public let color: String
}

public struct IssueCreateDTO: Codable {
  let title: String
  let body: String?
}

public struct FileContentDTO: Codable {
  public let name: String
  public let path: String
  public let sha: String
  public let size: Int
  public let url: String
  public let html_url: String
  public let git_url: String
  public let download_url: String
  public let type: String
}

public struct CreateFileResponseDTO: Codable {
  public let content: FileContentDTO
}

public struct CreateFileRequestDTO: Codable {
  public init(message: String, content: String, branch: String? = nil) {
    self.message = message
    self.content = content
    self.branch = branch
  }

  public let message: String
  public let content: String
  public let branch: String?
}

public struct CreateIssueDTO: Codable {
  public init(title: String, body: String) {
    self.title = title
    self.body = body
  }

  public var title: String
  public var body: String
}
