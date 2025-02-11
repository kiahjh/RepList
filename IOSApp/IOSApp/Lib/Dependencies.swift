import ComposableArchitecture

private enum APIClientKey: DependencyKey {
  static let liveValue = APIClient(fetcher: LiveFetcher(endpoint: "http://localhost:4000"))
  static let testValue = APIClient(fetcher: SuccessfulFetcher())
}

extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClientKey.self] }
    set { self[APIClientKey.self] = newValue }
  }
}

struct SuccessfulFetcher: Fetcher {
  struct SuccessfulFetcherError: Error {}

  func get<T>(from path: String, sessionToken: String?) async throws -> Response<T> {
    throw SuccessfulFetcherError()
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
      return .success(SuccessResponse(data: "test-session-token" as! T))
    case "login":
      return .success(SuccessResponse(data: "test-session-token" as! T))
    default:
      throw SuccessfulFetcherError()
    }
  }
}

struct FailingFetcher: Fetcher {
  func get<T>(from path: String, sessionToken: String?) async throws -> Response<T> {
    return .failure(FailureResponse(message: "test-error", status: 400))
  }

  func post<T: Decodable, U: Encodable>(
    to path: String,
    with body: U,
    returning type: T.Type,
    sessionToken: String?
  ) async throws -> Response<T> {
    return .failure(FailureResponse(message: "test-error", status: 400))
  }
}
