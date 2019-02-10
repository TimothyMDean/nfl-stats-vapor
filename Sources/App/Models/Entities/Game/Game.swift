import Fluent
import Vapor

/// An entity that describes a single NFL game
struct Game {

  var id: UUID?
  var scheduledTime: Date
  var homeTeamId: Team.ID
  var awayTeamId: Team.ID
  var weekId: Week.ID
  var createdAt: Date?
  var updatedAt: Date?

  /// Creates a new `Game` entity
  init(scheduledTime: Date, homeTeamId: Team.ID, awayTeamId: Team.ID, weekId: Week.ID) {
    self.scheduledTime = scheduledTime
    self.homeTeamId = homeTeamId
    self.awayTeamId = awayTeamId
    self.weekId = weekId
  }
}


/// Add support for automatic time-stamping of `Game` entities
extension Game {
  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt
}


/// Add methods to navigate `Game` entity's relationships
extension Game {

  /// Returns the parent week relationship
  var week: Parent<Game, Week> {
    return parent(\.weekId)
  }

  /// Returns the home team relationship
  var homeTeam: Parent<Game, Team> {
    return parent(\.homeTeamId)
  }

  /// Returns the away team relationship
  var awayTeam: Parent<Game, Team> {
    return parent(\.awayTeamId)
  }
}


/// Miscellaneous extensions for Vapor marker protocols
extension Game: Content {}
