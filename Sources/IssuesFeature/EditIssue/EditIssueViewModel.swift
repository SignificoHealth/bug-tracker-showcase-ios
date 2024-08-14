import Dependencies
import Entities
import Foundation
import Repository
import SwiftUINavigation

@Observable
final class EditIssueViewModel {
  @ObservationIgnored
  @Dependency(\.githubRepo) var repo

  @ObservationIgnored
  @Dependency(\.logger) var logger

  enum TabSelection: String, CaseIterable {
    case edit
    case preview
  }

  private let initialIssue: GithubIssue
  private let editingCompleted: (GithubIssue) -> Void

  var tabSelection: TabSelection = .edit
  var editingIssue: GithubIssue
  var isLoading: Bool = false
  var error: Error?

  var isInvalid: Bool {
    initialIssue == editingIssue || editingIssue.title.isEmpty
  }

  init(
    issue: GithubIssue,
    editingCompleted: @escaping (GithubIssue) -> Void
  ) {
    self.initialIssue = issue
    self.editingIssue = issue
    self.editingCompleted = editingCompleted
  }

  @MainActor
  func save() async throws {
    isLoading = true
    defer { isLoading = false }

    do {
      editingCompleted(try await repo.updateIssue(editingIssue))
    } catch {
      logger.log(level: .error, "\(error)")
      self.error = error
      throw error
    }
  }
}
