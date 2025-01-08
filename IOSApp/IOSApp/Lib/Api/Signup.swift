// Created by Fen v0.1.0 at 15:15:58 on 2025-01-08
// Do not manually modify this file as it is automatically generated

extension ApiClient {
  /// Create a new account for a user, returns a session token
  func signup(email: String, username: String, password: String) async throws -> Response<String> {
    return try await self.fetcher.post(
      to: "/signup",
      with: Input(payload: SignupInput(email: email, username: username, password: password)),
      returning: String.self
    )
  }
}

struct SignupInput: Encodable {
  var email: String
  var username: String
  var password: String
}