import Dependencies
import Entities
import Foundation
import Repository
import SwiftUINavigation

@Observable
final class IssueDetailViewModel {
  @CasePathable
  enum Destination {
    case editIssue(Referenced<GithubIssue>)
  }

  @ObservationIgnored
  @Dependency(\.githubRepo) var repo

  var issue: Referenced<GithubIssue>
  var destination: Destination?

  init(issue: Referenced<GithubIssue>) {
    self.issue = issue
  }

  func editTapped() {
    destination = .editIssue(issue)
  }
}
