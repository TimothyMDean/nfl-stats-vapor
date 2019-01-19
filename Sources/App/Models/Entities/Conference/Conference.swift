import Fluent
import Vapor

/// An entity that describes an NFL conference
struct Conference {

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

/// Add support for automatic time-stamping of `Conference` entities
extension Conference {
  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt
}

/// Add methods to navigate `Conference` entity's relationships
extension Conference {
  var divisions: Children<Conference, Division> {
    return children(\.conferenceId)
  }
}

/// Miscellaneous extensions for Vapor marker protocols
extension Conference: Content {}
