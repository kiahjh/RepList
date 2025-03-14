import ComposableArchitecture
import Foundation

let env = ProcessInfo.processInfo.environment
let isDev = env["IS_DEV"] == "true"

private enum APIClientKey: DependencyKey {
  static let liveValue = APIClient(
    fetcher: LiveFetcher(
      endpoint: isDev ? "http://localhost:4000" : "https://api.replist.innocencelabs.com"))
  static let testValue = APIClient(fetcher: SuccessfulFetcher())
  static let previewValue = APIClient(fetcher: SuccessfulFetcher())
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClientKey.self] }
    set { self[APIClientKey.self] = newValue }
  }
}

struct SuccessfulFetcher: Fetcher {
  struct SuccessfulFetcherError: Error {
    let message: String
  }

  func get<T>(from path: String, sessionToken: String?) async throws -> Response<T> {
    let trailingPath = path.split(separator: "/").last!
    switch trailingPath {
    case "get-user-repertoire":
      return .success(LearnedPiece.list as! T)
    default:
      throw SuccessfulFetcherError(message: "Unknown GET endpoing: \(trailingPath)")
    }
  }

  func post<T: Decodable, U: Encodable>(
    to path: String,
    with body: U,
    returning type: T.Type,
    sessionToken: String?
  ) async throws -> Response<T> {
    let trailingPath = path.split(separator: "/").last!
    switch trailingPath {
    case "signup":
      return .success("test-session-token" as! T)
    case "login":
      return .success("test-session-token" as! T)
    default:
      throw SuccessfulFetcherError(message: "Unknown POST endpoing: \(trailingPath)")
    }
  }
}

struct FailingFetcher: Fetcher {
  func get<T>(from path: String, sessionToken: String?) async throws -> Response<T> {
    return .failure(message: "test-error", status: 400)
  }

  func post<T: Decodable, U: Encodable>(
    to path: String,
    with body: U,
    returning type: T.Type,
    sessionToken: String?
  ) async throws -> Response<T> {
    return .failure(message: "test-error", status: 400)
  }
}
