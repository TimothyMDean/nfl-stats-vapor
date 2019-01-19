import Fluent
import Vapor

/// An entity that describes an NFL division
struct Division {

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

/// Add support for automatic time-stamping of `Division` entities
extension Division {
  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt
}

/// Add methods to navigate `Conference` entity's relationships
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

/// Miscellaneous extensions for Vapor marker protocols
extension Division: Content {}
