import Foundation

public struct GithubUser: Equatable, Hashable {
  public init(id: Int, name: String? = nil, email: String? = nil, login: String, avatarUrl: URL) {
    self.id = id
    self.name = name
    self.email = email
    self.login = login
    self.avatarUrl = avatarUrl
  }

  public let id: Int
  public let name: String?
  public let email: String?
  public let login: String
  public let avatarUrl: URL
}
