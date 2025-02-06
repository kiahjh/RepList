// Created by Fen v0.3.0 at 12:43:33 on 2025-02-06
// Do not manually modify this file as it is automatically generated

extension ApiClient {
  /// Log in a user, returns a session token
  func login(username: String, password: String) async throws -> Response<String> {
    return try await self.fetcher.post(
      to: "/_fen_/login",
      with: LoginInput(username: username, password: password),
      returning: String.self
    )
  }
}

struct LoginInput: Codable {
  var username: String
  var password: String
}