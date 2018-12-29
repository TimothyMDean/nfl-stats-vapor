import Foundation
import FluentSQLite
import Vapor

/// An entity that describes an NFL team
struct Team: Codable {

  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt

  var id: UUID?
  var name: String
  var abbreviation: String
  var divisionId: Division.ID
  var createdAt: Date?
  var updatedAt: Date?

  /// Creates a new Team entity
  init(name: String, abbreviation: String, divisionId: Division.ID) {
    self.name = name
    self.abbreviation = abbreviation
    self.divisionId = divisionId
  }
}

/// Extensions to the base team entity
extension Team {

  /// Returns the parent division relationship
  var division: Parent<Team, Division> {
    return parent(\.divisionId)
  }
}

// A custom migration for `Team` entities
extension Team: Migration {

  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
      try addProperties(to: builder)
      builder.reference(from: \.divisionId, to: \Division.id)
    }
  }
}

extension Team: SQLiteUUIDModel {}

extension Team: Content {}

extension Team: Parameter {}
