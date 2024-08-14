import Foundation

public struct GithubIssueLabel: Equatable, Hashable {
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

public struct CreateGithubIssue: Equatable, Hashable {
  public init(title: String, body: String? = nil) {
    self.title = title
    self.body = body
  }

  let title: String
  let body: String?
}

public struct GithubIssue: Equatable, Hashable {
  public init(
    id: Int, number: Int, state: GithubIssueState, title: String, body: String? = nil,
    user: GithubUser? = nil, labels: [GithubIssueLabel], assignee: GithubUser? = nil,
    assignees: [GithubUser]? = nil, comments: Int, closedAt: Date? = nil, createdAt: Date,
    updatedAt: Date
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
    self.closedAt = closedAt
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }

  public let id: Int
  public let number: Int
  public let state: GithubIssueState
  public var title: String
  public var body: String?
  public let user: GithubUser?
  public let labels: [GithubIssueLabel]
  public let assignee: GithubUser?
  public let assignees: [GithubUser]?
  public let comments: Int
  public let closedAt: Date?
  public let createdAt: Date
  public let updatedAt: Date
}

public enum GithubIssueState: Equatable, Hashable {
  case open
  case closed
}

public struct CreateIssueRequest: Equatable, Hashable {
  public init(title: String, body: String) {
    self.title = title
    self.body = body
  }

  public var title: String
  public var body: String
}

extension GithubIssue {
  public static var empty: GithubIssue {
    .init(
      id: 0, number: 0, state: .open, title: "", body: "", labels: [], comments: 0, createdAt: .now,
      updatedAt: .now)
  }
}
