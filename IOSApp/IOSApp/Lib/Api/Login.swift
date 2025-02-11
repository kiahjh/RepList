// Created by Fen v0.3.2 at 15:40:59 on 2025-02-11
// Do not manually modify this file as it is automatically generated

extension APIClient {
  /// Log in a user, returns a session token
  func login(username: String, password: String) async throws -> Response<String> {
    return try await self.fetcher.post(
      to: "/_fen_/login",
      with: LoginInput(username: username, password: password),
      returning: String.self,
      sessionToken: nil
    )
  }
}

struct LoginInput: Codable, Equatable {
  var username: String
  var password: String
}