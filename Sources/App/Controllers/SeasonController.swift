import Vapor

/// Controls basic CRUD operations on `Season`s.
final class SeasonController : RouteCollection {

  private let seasonRepository: SeasonRepository
  private let weekRepository: WeekRepository

  /// Initialize a new `SeasonController`
  init(seasonRepository: SeasonRepository, weekRepository: WeekRepository) {
    self.seasonRepository = seasonRepository
    self.weekRepository = weekRepository
  }

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let seasonsRoute = router.grouped("seasons")
    seasonsRoute.get(use: index)
    seasonsRoute.get(UUID.parameter, use: get)
    seasonsRoute.get(UUID.parameter, "weeks", use: getWeeks)
    seasonsRoute.get(UUID.parameter, "games", use: getGames)
    seasonsRoute.post(Season.self, use: create)
  }

  /// Returns a list of all `Season`s.
  func index(_ req: Request) throws -> Future<[Season]> {
    return self.seasonRepository.all()
  }

  /// Returns a specific `Season`
  func get(_ req: Request) throws -> Future<Season> {
    let seasonId = try req.parameters.next(UUID.self)
    return self.seasonRepository.find(id: seasonId)
      .unwrap(or: Abort(.notFound, reason: "Invalid season ID"))
  }

  /// Creates a new `Season` and returns its URL in the `Location` header
  func create(_ req: Request, season: Season) throws -> Future<HTTPResponse> {
    return req.transaction(on: .sqlite) { connection in
      return self.seasonRepository.save(season: season).flatMap(to: HTTPResponse.self) { season in
        guard let seasonId = season.id else { throw Abort(.internalServerError, reason: "Missing season ID")}
        let location = SeasonController.location(forId: seasonId)
        let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location))
        return (1...17)
          .map { Week(number: $0, seasonId: seasonId) }
          .map { self.weekRepository.save(week: $0) }
          .flatten(on: connection)
          .transform(to: HTTPResponse(status: .created, headers: responseHeaders))
      }
    }
  }

  /// Returns the list of `Week` entities within a `Season` entity
  func getWeeks(_ req: Request) throws -> Future<[Week]> {
    let seasonId = try req.parameters.next(UUID.self)
    return self.seasonRepository.find(id: seasonId)
      .unwrap(or: Abort(.notFound, reason: "Invalid season ID"))
      .flatMap(to: [Week].self) { season in
        try season.weeks.query(on: req).all()
      }
  }

  /// Returns the list of `Game` entities within a `Season` entity
  func getGames(_ req: Request) throws -> Future<[Game]> {
    let seasonId = try req.parameters.next(UUID.self)
    return self.seasonRepository.find(id: seasonId)
      .unwrap(or: Abort(.notFound, reason: "Invalid season ID"))
      .flatMap(to: [Game].self) { season in
        try season.games.query(on: req).all()
      }
  }

  // Returns the location path that should be used for a `Season` with a specified ID
  static func location(forId seasonId: Season.ID) -> String {
    return "/seasons/" + seasonId.description
  }
}
