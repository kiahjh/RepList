// Created by Fen v0.3.2 at 15:40:59 on 2025-02-11
// Do not manually modify this file as it is automatically generated

import Foundation

extension APIClient {
  /// Get a user's repertoire
  func getRepertoire(sessionToken: String) async throws -> Response<[Piece]> {
    return try await self.fetcher.get(from: "/_fen_/get-repertoire", sessionToken: sessionToken)
  }
}

struct Piece: Codable, Equatable, Identifiable {
  var id: UUID
  var title: String
  var familiarity: FamiliarityLevel
  var composer: String?
  var createdAt: Date
}

enum FamiliarityLevel: Codable, Equatable {
  case todo
  case learning
  case playable
  case good
  case mastered
}