import Vapor

/// Controls basic CRUD operations on `Week`s.
final class WeekController: RouteCollection {

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let weeksRoute = router.grouped("weeks")
    weeksRoute.get(use: index)
    weeksRoute.get(Week.parameter, use: get)
    weeksRoute.get(Week.parameter, "games", use: getGames)
    weeksRoute.post(CreateGameRequest.self, at: Week.parameter, "games", use: createGame)
  }

  /// Returns a list of all `Week`s.
  func index(_ req: Request) throws -> Future<[Week]> {
    return Week.query(on: req)
      .sort(\.seasonId, .ascending)
      .sort(\.number, .ascending)
      .all()
  }

  /// Returns a specific `Week`
  func get(_ req: Request) throws -> Future<Week> {
    return try req.parameters.next(Week.self)
  }

  /// Returns a list of `Game` entites within a specific `Week` entity
  func getGames(_ req: Request) throws -> Future<[Game]> {
    return try req.parameters.next(Week.self).flatMap(to: [Game].self) { week in
      try week.games.query(on: req).all()
    }
  }

  /// Create a new `Game` entity within a specific `Week` entity
  func createGame(_ req: Request, gameRequest: CreateGameRequest) throws -> Future<HTTPResponse> {
    return try req.parameters.next(Week.self).flatMap(to: HTTPResponse.self) { week in
      guard let weekId = week.id else { throw Abort(.internalServerError, reason: "Missing week ID") }
      let newGame = Game(
        scheduledTime: gameRequest.scheduledTime,
        homeTeamId: gameRequest.homeTeamId,
        awayTeamId: gameRequest.homeTeamId,
        weekId: weekId)
      return newGame.save(on: req).map(to: HTTPResponse.self) { game in
        guard let gameId = game.id else { throw Abort(.internalServerError, reason: "Missing game ID") }
        let location = GameController.location(forId: gameId)
        let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location))
        return HTTPResponse(status: .created, headers: responseHeaders)
      }
    }
  }
}
