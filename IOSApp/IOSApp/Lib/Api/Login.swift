import SwiftUI

extension Api {
  class LoginOutput: Codable, ObservableObject {
    var token: String
  }

  func login(
    username: String,
    password: String
  ) async throws -> Response<LoginOutput> {
    struct Body: Encodable {
      var username: String
      var password: String
    }
    let body = Body(username: username, password: password)

    let res = try await fetcher.post(
      to: "/login",
      with: body,
      returning: LoginOutput.self
    )

    return res
  }
}
