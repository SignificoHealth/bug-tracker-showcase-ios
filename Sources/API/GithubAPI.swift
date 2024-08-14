import Alamofire
import Dependencies

private let githubBaseUrl = "https://api.github.com"
private let owner = "SignificoHealth"
private let repo = "bug-tracker-showcase-ios"

public protocol GithubAPI {
  func getUser() async throws -> UserDTO
  func listIssues() async throws -> [IssueDTO]
  func getIssue(number: Int) async throws -> IssueDTO
  func updateIssue(number: Int, issue: IssueDTO) async throws -> IssueDTO
  func uploadFile(path: String, request: CreateFileRequestDTO) async throws -> CreateFileResponseDTO
  func create(issue: CreateIssueDTO) async throws -> IssueDTO
}

public struct LiveGithubAPI: GithubAPI {
  @Dependency(\.afSession) var session
  @Dependency(\.headerInterceptor) var interceptor

  public func getUser() async throws -> UserDTO {
    try await session
      .request(
        "\(githubBaseUrl)/user",
        method: .get,
        interceptor: interceptor,
        requestModifier: {
          $0.cachePolicy = .reloadIgnoringLocalCacheData
        }
      )
      .validate()
      .response(of: UserDTO.self)
  }

  public func getIssue(number: Int) async throws -> IssueDTO {
    try await session
      .request(
        "\(githubBaseUrl)/repos/\(owner)/\(repo)/issues/\(number)", method: .get,
        interceptor: interceptor
      )
      .validate()
      .response(of: IssueDTO.self)
  }

  public func listIssues() async throws -> [IssueDTO] {
    try await session
      .request(
        "\(githubBaseUrl)/repos/\(owner)/\(repo)/issues",
        method: .get,
        parameters: [
          "state": "open",
          "sort": "updated",
          "page": 1,
          "per_page": 100,  // for the purpouses of this demo we are not paginating
        ],
        interceptor: interceptor,
        requestModifier: {
          $0.cachePolicy = .reloadIgnoringLocalCacheData
        }
      )
      .validate()
      .response(of: [IssueDTO].self)
  }

  public func updateIssue(number: Int, issue: IssueDTO) async throws -> IssueDTO {
    try await session
      .request(
        "\(githubBaseUrl)/repos/\(owner)/\(repo)/issues/\(number)",
        method: .patch,
        parameters: try issue.parameters(),
        encoding: JSONEncoding.default,
        interceptor: interceptor
      )
      .validate()
      .response(of: IssueDTO.self)
  }

  public func uploadFile(path: String, request: CreateFileRequestDTO) async throws
    -> CreateFileResponseDTO
  {
    try await session
      .request(
        "\(githubBaseUrl)/repos/\(owner)/\(repo)/contents/\(path)",
        method: .put,
        parameters: try request.parameters(),
        encoding: JSONEncoding.default,
        interceptor: interceptor
      )
      .validate()
      .response(of: CreateFileResponseDTO.self)
  }

  public func create(issue: CreateIssueDTO) async throws -> IssueDTO {
    try await session
      .request(
        "\(githubBaseUrl)/repos/\(owner)/\(repo)/issues",
        method: .post,
        parameters: try issue.parameters(),
        encoding: JSONEncoding.default,
        interceptor: interceptor
      )
      .validate()
      .response(of: IssueDTO.self)
  }
}
