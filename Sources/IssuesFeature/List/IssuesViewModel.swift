import Dependencies
import Entities
import Foundation
import Logger
import Repository
import SwiftUINavigation

@Observable
final class IssuesViewModel {
  @CasePathable
  enum Destination: Equatable {
    static func == (lhs: IssuesViewModel.Destination, rhs: IssuesViewModel.Destination) -> Bool {
      switch (lhs, rhs) {
      case (.new, .issue), (.issue, .new):
        return false
      case let (.new(lhsCompletion), .new(rhsCompletion)):
        return lhsCompletion.id == rhsCompletion.id
      case let (.issue(lhsIssue), .issue(rhsIssue)):
        return lhsIssue == rhsIssue
      }
    }

    case new(CompletionBlock<()>)
    case issue(Referenced<GithubIssue>)
  }

  @ObservationIgnored
  @Dependency(\.logger) var logger

  @ObservationIgnored
  @Dependency(\.githubRepo) var repo

  init() {}

  var issues: [GithubIssue]?
  var destination: Destination?
  var error: Error?
  var isLoading: Bool = true

  @MainActor
  func getIssues(firstLoad: Bool = true) async throws {
    isLoading = firstLoad
    defer { isLoading = false }

    do {
      issues = try await repo.listIssues()
    } catch {
      logger.log(level: .error, "\(error)")
      self.error = error
      throw error
    }
  }

  func tapped(issue: Referenced<GithubIssue>) {
    destination = .issue(issue)
  }

  func tappedNewButton() {
    destination = .new(
      .init { [unowned self] newIssue in
        Task {
          try? await self.getIssues(firstLoad: false)
        }
      })
  }
}
