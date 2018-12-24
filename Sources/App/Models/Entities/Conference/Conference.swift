import FluentSQLite
import Vapor

/// An entity that describes an NFL conference
struct Conference: SQLiteUUIDModel {

  var id: UUID?
  var name: String
  var assetPrefix: String

  /// Creates a new Conference entity
  init(id: UUID? = nil, name: String, assetPrefix: String) {
    self.id = id
    self.name = name
    self.assetPrefix = assetPrefix
  }
}

extension Conference: Content {}

extension Conference: Migration {}

extension Conference: Parameter {}
