import Alamofire
import Dependencies
import Foundation
import SwiftDotenv

// MARK: Internal dependencies

enum AFSessionKey: DependencyKey {
  public static var liveValue: Alamofire.Session {
    .default
  }
}

public enum RequestInterceptorKey: DependencyKey {
  public static var liveValue: any RequestInterceptor {
    Interceptor(adapters: [HeadersAdapter()])
  }
}

public enum GithubTokenKey: DependencyKey {
  public static var liveValue: String {
    let envPath = (#filePath).split(separator: "/").dropLast(1).joined(separator: "/").appending(
      "/.env")
    try? Dotenv.configure(atPath: envPath)
    guard let token = Dotenv["GITHUB_TOKEN"]?.stringValue else {
      preconditionFailure(
        "Please make sure your .env file is correcly located inside /Sources/API/.env")
    }
    return token
  }
}

extension DependencyValues {
  var afSession: Session {
    get { self[AFSessionKey.self] }
    set { self[AFSessionKey.self] = newValue }
  }

  var headerInterceptor: RequestInterceptor {
    get { self[RequestInterceptorKey.self] }
    set { self[RequestInterceptorKey.self] = newValue }
  }

  var githubToken: String {
    get { self[GithubTokenKey.self] }
    set { self[GithubTokenKey.self] = newValue }
  }
}

// MARK: External

enum GithubAPIKey: DependencyKey {
  public static var liveValue: any GithubAPI { LiveGithubAPI() }
}

extension DependencyValues {
  public var githubApi: GithubAPI {
    get { self[GithubAPIKey.self] }
    set { self[GithubAPIKey.self] = newValue }
  }
}
