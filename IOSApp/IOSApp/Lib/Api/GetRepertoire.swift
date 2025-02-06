// Created by Fen v0.3.0 at 12:43:33 on 2025-02-06
// Do not manually modify this file as it is automatically generated

import Foundation

extension ApiClient {
  /// Get a user's repertoire
  func getRepertoire(sessionToken: String) async throws -> Response<[Piece]> {
    return try await self.fetcher.get(from: "/_fen_/get-repertoire", sessionToken: sessionToken)
  }
}

struct Piece: Codable, Identifiable {
  var id: UUID
  var title: String
  var familiarity: FamiliarityLevel
  var composer: String?
  var createdAt: Date
}

enum FamiliarityLevel: Codable {
  case todo
  case learning
  case playable
  case good
  case mastered
}