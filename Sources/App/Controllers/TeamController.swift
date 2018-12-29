import Vapor

/// Controls basic CRUD operations on `Team`s.
final class TeamController: RouteCollection {

  /// Registers this controller's routes at boot time
  func boot(router: Router) throws {
    let teamsRoute = router.grouped("teams")
    teamsRoute.get(use: index)
    teamsRoute.get(Team.parameter, use: get)
    teamsRoute.get(Team.parameter, "division", use: getDivision)
  }

  /// Returns a list of all `Team`s.
  func index(_ req: Request) throws -> Future<[Team]> {
      return Team.query(on: req).all()
  }

  /// Returns a specific `Team`
  func get(_ req: Request) throws -> Future<Team> {
    return try req.parameters.next(Team.self)
  }

  /// Returns the `Division` for a `Team`
  func getDivision(_ req: Request) throws -> Future<Division> {
    return try req.parameters.next(Team.self).flatMap { team in
      team.division.get(on: req)
    }
  }
}
