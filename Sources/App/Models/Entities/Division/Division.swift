import Foundation
import FluentSQLite
import Vapor

/// An entity that describes an NFL division
struct Division: Codable {

  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt

  var id: UUID?
  var name: String
  var conferenceId: Conference.ID
  var createdAt: Date?
  var updatedAt: Date?

  /// Creates a new Division entity
  init(name: String, conferenceId: Conference.ID) {
    self.name = name
    self.conferenceId = conferenceId
  }
}

/// Extension to the base division entity that adds relationship properties
extension Division {

  /// Returns the parent conference relationship
  var conference: Parent<Division, Conference> {
    return parent(\.conferenceId)
  }

  /// Returns the child teams relationship
  var teams: Children<Division, Team> {
    return children(\.divisionId)
  }
}

// A custom migration for `Division` entities
extension Division: Migration {

  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
      try addProperties(to: builder)
      builder.reference(from: \.conferenceId, to: \Conference.id)
    }
  }
}

extension Division: SQLiteUUIDModel {}

extension Division: Content {}

extension Division: Parameter {}
