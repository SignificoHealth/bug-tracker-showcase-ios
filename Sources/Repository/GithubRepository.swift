import API
import Dependencies
import Entities
import Foundation

public struct GithubRepository {
  public var getUser: () async throws -> GithubUser
  public var listIssues: () async throws -> [GithubIssue]
  public var getIssue: (Int) async throws -> GithubIssue
  public var updateIssue: (GithubIssue) async throws -> GithubIssue
  public var uploadFile: (URL) async throws -> CreateGithubBranchFileResponse
  public var create: (CreateIssueRequest) async throws -> GithubIssue
}

extension GithubRepository: DependencyKey {
  public static var liveValue: GithubRepository {
    @Dependency(\.githubApi) var api

    return .init(
      getUser: {
        let user = try await api.getUser()
        return try GithubUser(dto: user)
      },
      listIssues: {
        let issues = try await api.listIssues()
        return try issues.map(GithubIssue.init)
      },
      getIssue: { number in
        let issue = try await api.getIssue(number: number)
        return try GithubIssue(dto: issue)
      },
      updateIssue: { issue in
        let issue = try await api.updateIssue(number: issue.number, issue: .init(entity: issue))
        return try .init(dto: issue)
      },
      uploadFile: { url in
        let fileName = url.lastPathComponent
        let pathInRepo = "attachments/\(Date.now)-\(fileName)"
        let response = try await api.uploadFile(
          path: pathInRepo,
          request: .init(
            entity: .init(
              message: "Add file \(pathInRepo)",
              content: try Data(contentsOf: url).base64EncodedString(),
              branch: "main"
            )
          )
        )

        return try .init(dto: response)
      },
      create: { request in
        let dto = try await api.create(issue: .init(entity: request))
        return try .init(dto: dto)
      }
    )
  }
}
