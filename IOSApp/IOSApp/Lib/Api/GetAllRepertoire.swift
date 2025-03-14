// Created by Fen v0.5.3 at 20:08:54 on 2025-03-13
// Do not manually modify this file as it is automatically generated

import Foundation

extension APIClient {
  /// Get all repertoire
  func getAllRepertoire(sessionToken: String) async throws -> Response<[Piece]> {
    return try await self.fetcher.get(from: "/_fen_/get-all-repertoire", sessionToken: sessionToken)
  }
}

struct Piece: Codable, Equatable, Identifiable {
  var id: UUID
  var title: String
  var composer: String?
  var createdAt: Date

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case composer
    case createdAt
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(self.id, forKey: .id)
    try container.encode(self.title, forKey: .title)
    switch self.composer {
    case let .some(value):
      try container.encode(value, forKey: .composer)
    case .none:
      try container.encodeNil(forKey: .composer)
    }
    try container.encode(self.createdAt, forKey: .createdAt)
  }
}

