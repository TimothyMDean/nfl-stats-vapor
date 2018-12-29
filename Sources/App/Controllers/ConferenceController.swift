import Vapor

/// Controls basic CRUD operations on `Conference`s.
final class ConferenceController: RouteCollection {

    /// Registers this controller's routes at boot time
    func boot(router: Router) throws {
      let conferencesRoute = router.grouped("conferences")
      conferencesRoute.get(use: index)
      conferencesRoute.get(Conference.parameter, use: get)
      conferencesRoute.get(Conference.parameter, "divisions", use: getDivisions)
    }

    /// Returns a list of all `Conference`s.
    func index(_ req: Request) throws -> Future<[Conference]> {
        return Conference.query(on: req).all()
    }

    /// Returns a specific `Conference`
    func get(_ req: Request) throws -> Future<Conference> {
      return try req.parameters.next(Conference.self)
    }

    /// Returns the `Division` children of a specific `Conference`
    func getDivisions(_ req: Request) throws -> Future<[Division]> {
      return try req.parameters.next(Conference.self).flatMap(to: [Division].self) { conference in
        try conference.divisions.query(on: req).all()
      }
    }
}
