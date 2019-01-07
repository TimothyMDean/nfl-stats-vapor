import Vapor

/// Controls basic CRUD operations on `Week`s.
final class WeekController: RouteCollection {

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let weeksRoute = router.grouped("weeks")
    weeksRoute.get(use: index)
    weeksRoute.get(Week.parameter, use: get)
    weeksRoute.get(Week.parameter, "games", use: getGames)
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
}
