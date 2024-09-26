import Foundation

public struct User: Sendable, Equatable, Codable {
  public var name: String
  public var id: UUID

  public init(name: String, id: UUID) {
    self.name = name
    self.id = id
  }
}
