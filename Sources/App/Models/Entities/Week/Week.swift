import Foundation
import FluentSQLite
import Vapor

/// An entity that describes a week in an NFL season
struct Week: Codable {

  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt

  var id: UUID?
  var number: Int
  var seasonId: Season.ID
  var createdAt: Date?
  var updatedAt: Date?

  /// Creates a new `Week` entity
  init(number: Int, seasonId: Season.ID) {
    self.number = number
    self.seasonId = seasonId
  }
}

/// Extension to the base week entity that adds relationship properties
extension Week {

  /// Returns the parent season relationship
  var season: Parent<Week, Season> {
    return parent(\.seasonId)
  }

  /// Returns the child games relationship
  var games: Children<Week, Game> {
    return children(\.weekId)
  }
}


extension Week: SQLiteUUIDModel {}

extension Week: Content {}

extension Week: Parameter {}

extension Week: Migration {}
