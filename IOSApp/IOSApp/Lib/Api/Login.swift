// Created by Fen v0.1.0 at 15:15:58 on 2025-01-08
// Do not manually modify this file as it is automatically generated

extension ApiClient {
  /// Log in a user, returns a session token
  func login(username: String, password: String) async throws -> Response<String> {
    return try await self.fetcher.post(
      to: "/login",
      with: Input(payload: LoginInput(username: username, password: password)),
      returning: String.self
    )
  }
}

struct LoginInput: Encodable {
  var username: String
  var password: String
}