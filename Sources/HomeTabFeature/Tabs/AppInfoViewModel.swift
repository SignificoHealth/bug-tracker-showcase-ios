import Dependencies
import Entities
import Foundation
import Logger
import Repository
import SwiftUINavigation

@Observable
final class AppInfoViewModel {
  @CasePathable
  enum Destination {
    case issues
  }

  @ObservationIgnored
  @Dependency(\.githubRepo) var repo

  @ObservationIgnored
  @Dependency(\.logger) var logger

  var user: GithubUser?
  var error: Error?
  var isLoading: Bool = false
  var destination: Destination?

  @MainActor
  func getGithubUser() async throws {
    isLoading = true
    defer { isLoading = false }

    do {
      self.user = try await repo.getUser()
    } catch {
      logger.log(level: .error, "\(error)")
      self.error = error
      throw error
    }
  }

  func startButtonTapped() {
    destination = .issues
  }
}
