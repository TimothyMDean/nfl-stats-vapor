import Foundation
import FluentSQLite
import Vapor

/// An entity that describes an NFL team
struct Team : Codable {

  var id: UUID?
  var name: String
  var abbreviation: String
  var conferenceId: Conference.ID
  var divisionId: Division.ID
  var createdAt: Date?
  var updatedAt: Date?

  /// Creates a new Team entity
  init(name: String, abbreviation: String, conferenceId: Conference.ID, divisionId: Division.ID) {
    self.name = name
    self.abbreviation = abbreviation
    self.conferenceId = conferenceId
    self.divisionId = divisionId
  }
}

/// Add support for automatic time–stamping of `Team` entities
extension Team {
  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt
}

/// Add methods to navigate `Team` entity’s relationships
extension Team {

  /// Returns the parent division relationship
  var division: Parent<Team, Division> {
    return parent(\.divisionId)
  }

  /// Returns the parent conference relationship
  var conference: Parent<Team, Conference> {
    return parent(\.conferenceId)
  }
}

extension Team : Content {}
