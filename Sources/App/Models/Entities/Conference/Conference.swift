import Foundation
import FluentSQLite
import Vapor

/// An entity that describes an NFL conference
struct Conference: Codable {

  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt

  var id: UUID?
  var name: String
  var assetPrefix: String
  var createdAt: Date?
  var updatedAt: Date?

  /// Creates a new Conference entity
  init(name: String, assetPrefix: String) {
    self.name = name
    self.assetPrefix = assetPrefix
  }
}

extension Conference: SQLiteUUIDModel {}

extension Conference: Content {}

extension Conference: Parameter {}

extension Conference: Migration {}
