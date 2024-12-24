import Foundation

struct Api {
  var fetcher: Fetcher
}

let api = Api(fetcher: Fetcher(endpoint: "http://localhost:4000"))

enum Response<T: Decodable>: Decodable {
  case success(status: Int, data: T)
  case failure(status: Int, code: Int, message: String)

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if try container.decode(Bool.self, forKey: .success) {
      self = try .success(
        status: container.decode(Int.self, forKey: .status),
        data: container.decode(T.self, forKey: .data)
      )
    } else {
      self = try .failure(
        status: container.decode(Int.self, forKey: .status),
        code: container.decode(Int.self, forKey: .code),
        message: container.decode(String.self, forKey: .message)
      )
    }
  }

  enum CodingKeys: String, CodingKey {
    case success
    case status
    case data
    case code
    case message
  }
}

struct Fetcher {
  var endpoint: String

  let jsonEncoder = JSONEncoder()
  let jsonDecoder = JSONDecoder()

  func get<T>(from path: String) async throws -> Response<T> where T: Decodable {
    let url = URL(string: self.endpoint + path)!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try self.jsonDecoder.decode(Response<T>.self, from: data)
  }

  func post<T: Decodable>(
    to path: String,
    with body: Encodable,
    returning type: T.Type
  ) async throws -> Response<T> {
    let url = URL(string: self.endpoint + path)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = try self.jsonEncoder.encode(body)
    request.httpBody = body

    let (data, _) = try await URLSession.shared.data(for: request)

    return try self.jsonDecoder.decode(Response<T>.self, from: data)
  }
}

class Request<T: Decodable & ObservableObject>: ObservableObject {
  @Published var state: RequestState<T> = .idle
  var fn: () async throws -> Response<T> = { throw URLError(.badURL) }

  func fire() async {
    self.state = .loading
    do {
      let response = try await self.fn()
      self.state = .done(response)
    } catch {
      self.state = .error(error)
    }
  }
}

enum RequestState<T: Decodable> {
  case idle
  case loading
  case done(Response<T>)
  case error(Error)
}

extension RequestState: Equatable {
  static func == (lhs: RequestState, rhs: RequestState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case (.loading, .loading):
      return true
    case (.done, .done): // might need to change this
      return true
    case (.error, .error):
      return true
    default:
      return false
    }
  }
}
