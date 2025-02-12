// Created by Fen v0.4.0 at 10:29:33 on 2025-02-12
// Do not manually modify this file as it is automatically generated

extension APIClient {
  /// Create a new account for a user, returns a session token
  func signup(email: String, username: String, password: String) async throws -> Response<String> {
    return try await self.fetcher.post(
      to: "/_fen_/signup",
      with: SignupInput(email: email, username: username, password: password),
      returning: String.self,
      sessionToken: nil
    )
  }
}

struct SignupInput: Codable, Equatable {
  var email: String
  var username: String
  var password: String
}