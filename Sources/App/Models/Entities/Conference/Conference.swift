import Foundation
import FluentSQLite
import Vapor

/// An entity that describes an NFL conference
struct Conference: Codable {

  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt

  var id: UUID?
  var name: String
  var abbreviation: String
  var createdAt: Date?
  var updatedAt: Date?

  /// Creates a new Conference entity
  init(name: String, abbreviation: String) {
    self.name = name
    self.abbreviation = abbreviation
  }
}

/// Extensions to the base conference entity
extension Conference {

  /// Returns the child divisions relationship
  var divisions: Children<Conference, Division> {
    return children(\.conferenceId)
  }
}


extension Conference: SQLiteUUIDModel {}

extension Conference: Content {}

extension Conference: Parameter {}

extension Conference: Migration {}
