import Vapor

/// A type that describes a request to create a new NFL game
struct CreateGameRequest: Content {

  var scheduledTime: Date
  var homeTeamId: Team.ID
  var awayTeamId: Team.ID

  /// Creates a new `CreateGameRequest` entity
  init(scheduledTime: Date, homeTeamId: Team.ID, awayTeamId: Team.ID) {
    self.scheduledTime = scheduledTime
    self.homeTeamId = homeTeamId
    self.awayTeamId = awayTeamId
  }
}
