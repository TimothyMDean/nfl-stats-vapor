import Foundation
import FluentSQLite
import Vapor

/// An entity that describes a single NFL game
struct Game: Codable {

  static var createdAtKey: TimestampKey? = \.createdAt
  static var updatedAtKey: TimestampKey? = \.updatedAt

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

/// Extension to the base game entity that adds relationship properties
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


extension Game: SQLiteUUIDModel {}

extension Game: Content {}

extension Game: Parameter {}

extension Game: Migration {}
