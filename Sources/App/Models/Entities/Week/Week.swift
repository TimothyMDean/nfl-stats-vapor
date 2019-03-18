import Fluent
import Vapor

/// An entity that describes a week in an NFL season
struct Week : Codable {

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

/// Add support for automatic time-stamping of `Week` entities
extension Week {
  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt
}

/// Add methods to navigate `Week` entity's relationships
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

/// Miscellaneous extensions for Vapor marker protocols
extension Week : Content {}
