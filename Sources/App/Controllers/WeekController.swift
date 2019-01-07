import Vapor

/// Controls basic CRUD operations on `Week`s.
final class WeekController: RouteCollection {

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let seasonsRoute = router.grouped("weeks")
    seasonsRoute.get(use: index)
    seasonsRoute.get(Week.parameter, use: get)
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
}
