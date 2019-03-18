import Vapor

/// Controls basic CRUD operations on `Team`s.
final class TeamController : RouteCollection {

  private let repository: TeamRepository

  /// Initialize a new `TeamController`
  init(repository: TeamRepository) {
    self.repository = repository
  }

  /// Registers this controller’s routes at boot time
  func boot(router: Router) throws {
    let teamsRoute = router.grouped("teams")
    teamsRoute.get(use: index)
    teamsRoute.get(UUID.parameter, use: get)
    teamsRoute.get(UUID.parameter, "division", use: getDivision)
    teamsRoute.get(UUID.parameter, "conference", use: getConference)
  }

  /// Returns a list of all `Team`s.
  func index(_ req: Request) throws -> Future<[Team]> {
      return Team.query(on: req).all()
  }

  /// Returns a specific `Team`
  func get(_ req: Request) throws -> Future<Team> {
    let teamId = try req.parameters.next(UUID.self)
    return self.repository.find(id: teamId)
      .unwrap(or: Abort(.notFound, reason: "Invalid team ID"))
  }

  /// Returns the `Division` for a `Team`
  func getDivision(_ req: Request) throws -> Future<Division> {
    let teamId = try req.parameters.next(UUID.self)
    return self.repository.find(id: teamId)
      .unwrap(or: Abort(.notFound, reason: "Invalid team ID"))
      .flatMap { team in
        team.division.get(on: req)
      }
  }

  /// Returns the `Conference` for a `Team`
  func getConference(_ req: Request) throws -> Future<Conference> {
    let teamId = try req.parameters.next(UUID.self)
    return self.repository.find(id: teamId)
      .unwrap(or: Abort(.notFound, reason: "Invalid team ID"))
      .flatMap { team in
        team.conference.get(on: req)
      }
  }
}
