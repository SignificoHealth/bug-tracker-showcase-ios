import Alamofire
import Foundation

extension DataRequest {
  func response<T: Decodable>(
    of type: T.Type = T.self,
    queue: DispatchQueue = .main,
    decoder: DataDecoder = JSONDecoder()
  ) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      responseDecodable(
        of: type,
        queue: queue,
        decoder: decoder
      ) { response in
        switch response.result {
        case let .success(data):
          continuation.resume(returning: data)

        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}

extension Encodable {
  func parameters() throws -> Alamofire.Parameters? {
    let data = try JSONEncoder().encode(self)
    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

    return json as? [String: Any]
  }
}
