import Vapor

/// Controls basic CRUD operations on `Division`s.
final class DivisionController: RouteCollection {

  /// Registers this controller's routes at boot time
  func boot(router: Router) throws {
    let divisionsRoute = router.grouped("divisions")
    divisionsRoute.get(use: index)
    divisionsRoute.get(Division.parameter, use: get)
    divisionsRoute.get(Division.parameter, "conference", use: getConference)
  }

  /// Returns a list of all `Division`s.
  func index(_ req: Request) throws -> Future<[Division]> {
      return Division.query(on: req).all()
  }

  /// Returns a specific `Division`
  func get(_ req: Request) throws -> Future<Division> {
    return try req.parameters.next(Division.self)
  }

  /// Returns the `Conference` for a `Division`
  func getConference(_ req: Request) throws -> Future<Conference> {
    return try req.parameters.next(Division.self).flatMap { division in
      division.conference.get(on: req)
    }
  }
}
