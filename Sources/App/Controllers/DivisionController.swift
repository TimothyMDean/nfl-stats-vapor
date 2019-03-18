import Vapor

/// Controls basic CRUD operations on `Division`s.
final class DivisionController : RouteCollection {

  private let repository: DivisionRepository

  /// Initialize a new `DivisionController`
  init(repository: DivisionRepository) {
    self.repository = repository
  }

  /// Registers this controller's routes at boot time
  func boot(router: Router) throws {
    let divisionsRoute = router.grouped("divisions")
    divisionsRoute.get(use: index)
    divisionsRoute.get(UUID.parameter, use: get)
    divisionsRoute.get(UUID.parameter, "conference", use: getConference)
    divisionsRoute.get(UUID.parameter, "teams", use: getTeams)
  }

  /// Returns a list of all `Division`s.
  func index(_ req: Request) throws -> Future<[Division]> {
      return Division.query(on: req).all()
  }

  /// Returns a specific `Division`
  func get(_ req: Request) throws -> Future<Division> {
    let divisionId = try req.parameters.next(UUID.self)
    return self.repository.find(id: divisionId)
      .unwrap(or: Abort(.notFound, reason: "Invalid division ID"))
  }

  /// Returns the `Conference` for a `Division`
  func getConference(_ req: Request) throws -> Future<Conference> {
    let divisionId = try req.parameters.next(UUID.self)
    return self.repository.find(id: divisionId)
      .unwrap(or: Abort(.notFound, reason: "Invalid division ID"))
      .flatMap { division in
        division.conference.get(on: req)
      }
  }

  /// Returns the `Team` children of a specific `Division`
  func getTeams(_ req: Request) throws -> Future<[Team]> {
    let divisionId = try req.parameters.next(UUID.self)
    return self.repository.find(id: divisionId)
      .unwrap(or: Abort(.notFound, reason: "Invalid division ID"))
      .flatMap { division in
        try division.teams.query(on: req).all()
      }
  }
}
