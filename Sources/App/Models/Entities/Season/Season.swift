import Foundation
import FluentSQLite
import Vapor

/// An entity that describes an NFL season
struct Season: Codable {

  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt

  var id: UUID?
  var primaryYear: Int
  var label: String
  var activatedAt: Date?
  var inactivatedAt: Date?
  var createdAt: Date?
  var updatedAt: Date?

  /// Creates a new `Season` entity. The new season will not initially be
  /// activated. Use the activate method to activate season.
  init(primaryYear: Int, label: String) {
    self.primaryYear = primaryYear
    self.label = label
  }

  /// Activates a `Season` entity.  Marking a season as activated will cause
  /// it to be treated as the current season until it is eventually deactivated.
  mutating func activate() {
    self.activatedAt = Date()
    self.inactivatedAt = nil
  }

  /// Deactivates a `Season` entity. Marking a season is typically done when the
  /// season is over and before a new season is activated.
  mutating func inactivate() {
    self.inactivatedAt = Date()
  }
}


/// Extensions to the base season entity
extension Season {

  /// Returns the child weeks relationship
  var weeks: Children<Season, Week> {
    return children(\.seasonId)
  }
}


extension Season: SQLiteUUIDModel {}

extension Season: Content {}

extension Season: Parameter {}

extension Season: Migration {}
