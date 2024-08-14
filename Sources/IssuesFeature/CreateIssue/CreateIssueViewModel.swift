import CasePaths
import Dependencies
import Entities
import Foundation
import Logger
import Repository

@Observable
final class CreateIssueViewModel {
  @ObservationIgnored
  @Dependency(\.githubRepo) var repo

  @ObservationIgnored
  @Dependency(\.logger) var logger

  enum TabSelection: String, CaseIterable {
    case edit
    case preview
  }

  @CasePathable
  enum Destination {
    case fileImporter
  }

  private let completion: () -> Void

  @ObservationIgnored
  var selectedUrl: URL?

  var attachedFiles: [CreateGithubBranchFileResponse] = []
  var destination: Destination?
  var tabSelection: TabSelection = .edit
  var newIssue: GithubIssue = .empty
  var createLoading: Bool = false
  var fileLoading: Bool = false
  var sendError: Error?
  var fileError: Error?

  var isInvalid: Bool {
    newIssue.title.isEmpty
  }

  init(completion: @escaping () -> Void) {
    self.completion = completion
  }

  func tappedOnAttachDocument() {
    destination = .fileImporter
  }

  @MainActor
  func tappedOnSave() async throws {
    createLoading = true
    do {
      _ = try await repo.create(
        .init(title: newIssue.title, body: newIssue.body(with: attachedFiles))
      )

      completion()
    } catch {
      logger.log(level: .error, "\(error)")
      sendError = error
      throw error
    }
    createLoading = false
  }

  func retryFileUpload() async throws {
    if let selectedUrl {
      try await sendFile(url: selectedUrl)
    }
  }

  @MainActor
  func sendFile(url: URL) async throws {
    fileLoading = true
    selectedUrl = url

    do {
      attachedFiles = [try await repo.uploadFile(url)]
    } catch {
      logger.log(level: .error, "\(error)")
      fileError = error
      throw error
    }

    fileLoading = false
  }
}
