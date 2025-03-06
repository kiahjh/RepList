// Created by Fen v0.5.3 at 14:55:53 on 2025-03-05
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

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case familiarity
    case composer
    case createdAt
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(self.id, forKey: .id)
    try container.encode(self.title, forKey: .title)
    try container.encode(self.familiarity, forKey: .familiarity)
    switch self.composer {
    case let .some(value):
      try container.encode(value, forKey: .composer)
    case .none:
      try container.encodeNil(forKey: .composer)
    }
    try container.encode(self.createdAt, forKey: .createdAt)
  }
}

enum FamiliarityLevel: Codable, Equatable {
  case todo
  case learning
  case playable
  case good
  case mastered

  private enum CodingKeys: String, CodingKey {
    case type
  }

  private enum FamiliarityLevelType: String, Codable {
    case todo
    case learning
    case playable
    case good
    case mastered
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(FamiliarityLevelType.self, forKey: .type)

    switch type {
    case .todo:
      self = .todo
    case .learning:
      self = .learning
    case .playable:
      self = .playable
    case .good:
      self = .good
    case .mastered:
      self = .mastered
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .todo:
      try container.encode(FamiliarityLevelType.todo, forKey: .type)
    case .learning:
      try container.encode(FamiliarityLevelType.learning, forKey: .type)
    case .playable:
      try container.encode(FamiliarityLevelType.playable, forKey: .type)
    case .good:
      try container.encode(FamiliarityLevelType.good, forKey: .type)
    case .mastered:
      try container.encode(FamiliarityLevelType.mastered, forKey: .type)
    }
  }
}