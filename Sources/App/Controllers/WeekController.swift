import Vapor

/// Controls basic CRUD operations on `Week`s.
final class WeekController: RouteCollection {

  private let repository: WeekRepository

  /// Initialize a new `WeekController`
  init(repository: WeekRepository) {
    self.repository = repository
  }

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let weeksRoute = router.grouped("weeks")
    weeksRoute.get(use: index)
    weeksRoute.get(UUID.parameter, use: get)
    weeksRoute.get(UUID.parameter, "games", use: getGames)
    weeksRoute.post(Week.self, use: create)
    weeksRoute.post(CreateGameRequest.self, at: UUID.parameter, "games", use: createGame)
  }

  /// Returns a list of all `Week`s.
  func index(_ req: Request) throws -> Future<[Week]> {
    return self.repository.all()
  }

  /// Returns a specific `Week`
  func get(_ req: Request) throws -> Future<Week> {
    let weekId = try req.parameters.next(UUID.self)
    return self.repository.find(id: weekId)
      .unwrap(or: Abort(.notFound, reason: "Invalid week ID"))
  }

  /// Creates a new `Week` and returns its URL in the `Location` header
  func create(_ req: Request, week: Week) throws -> Future<HTTPResponse> {
    return req.transaction(on: .sqlite) { connection in
      return self.repository.save(week: week).map(to: HTTPResponse.self) { week in
        guard let weekId = week.id else { throw Abort(.internalServerError, reason: "Missing week ID")}
        let location = WeekController.location(forId: weekId)
        let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location))
        return HTTPResponse(status: .created, headers: responseHeaders)
      }
    }
  }

  /// Returns a list of `Game` entities within a specific `Week` entity
  func getGames(_ req: Request) throws -> Future<[Game]> {
    let weekId = try req.parameters.next(UUID.self)
    return self.repository.find(id: weekId)
      .unwrap(or: Abort(.notFound, reason: "Invalid week ID"))
      .flatMap(to: [Game].self) { week in
        try week.games.query(on: req).all()
      }
  }

  /// Create a new `Game` entity within a specific `Week` entity
  func createGame(_ req: Request, gameRequest: CreateGameRequest) throws -> Future<HTTPResponse> {
    let weekId = try req.parameters.next(UUID.self)
    return self.repository.find(id: weekId)
      .flatMap(to: HTTPResponse.self) { week in
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

  /// Returns the location path that should be used for a `Week` with a specified ID
  static func location(forId weekId: Week.ID) -> String {
    return "/weeks/" + weekId.description
  }
}
