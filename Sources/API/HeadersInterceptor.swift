import Alamofire
import Dependencies
import Foundation

struct HeadersAdapter: RequestAdapter {
  @Dependency(\.githubToken) var token

  func adapt(
    _ urlRequest: URLRequest, for session: Session,
    completion: @escaping (Result<URLRequest, any Error>) -> Void
  ) {
    var copy = urlRequest
    copy.setValue("application/json", forHTTPHeaderField: "Accept")
    copy.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    completion(.success(copy))
  }
}
