import SwiftUI

extension Api {
  class SignupOutput: Codable, ObservableObject {
    var token: String
  }

  func signup(
    email: String,
    username: String,
    password: String
  ) async throws -> Response<SignupOutput> {
    struct Body: Encodable {
      var email: String
      var username: String
      var password: String
    }
    let body = Body(email: email, username: username, password: password)

    let res = try await fetcher.post(
      to: "/signup",
      with: body,
      returning: SignupOutput.self
    )

    return res
  }
}
