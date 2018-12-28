import Vapor

/// Controls basic CRUD operations on `Division`s.
final class DivisionController: RouteCollection {

  /// Registers this controller's routes at boot time
  func boot(router: Router) throws {
    let divisionsRoute = router.grouped("divisions")
    divisionsRoute.get(use: index)
    divisionsRoute.get(Division.parameter, use: get)
    divisionsRoute.get(Division.parameter, "conference", use: getConference)
    divisionsRoute.post(Division.self, use: create)
    divisionsRoute.delete(Division.parameter, use: delete)
  }

  /// Returns a list of all `Division`s.
  func index(_ req: Request) throws -> Future<[Division]> {
      return Division.query(on: req).all()
  }

  /// Returns a specific `Division`
  func get(_ req: Request) throws -> Future<Division> {
    return try req.parameters.next(Division.self)
  }

  /// Saves a decoded `Division` to the database.
  func create(_ req: Request, division: Division) throws -> Future<Division> {
    return division.save(on: req)
  }

  /// Deletes a parameterized `Division`.
  func delete(_ req: Request) throws -> Future<HTTPStatus> {
      return try req.parameters.next(Division.self).flatMap { division in
          return division.delete(on: req)
      }.transform(to: .ok)
  }

  /// Returns the `Conference` for a `Division`
  func getConference(_ req: Request) throws -> Future<Conference> {
    return try req.parameters.next(Division.self).flatMap { division in
      division.conference.get(on: req)
    }
  }
}
