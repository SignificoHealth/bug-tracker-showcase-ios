import Dependencies
import Foundation

extension DependencyValues {
  public var githubRepo: GithubRepository {
    get { self[GithubRepository.self] }
    set { self[GithubRepository.self] = newValue }
  }
}
