import Vapor

/// Controls basic CRUD operations on `Conference`s.
final class ConferenceController: RouteCollection {

  private let repository: ConferenceRepository

  /// Initialize a new `ConferenceController`
  init(repository: ConferenceRepository) {
    self.repository = repository
  }

  /// Registers this controller's routes at boot time
  func boot(router: Router) throws {
    let conferencesRoute = router.grouped("conferences")
    conferencesRoute.get(use: index)
    conferencesRoute.get(UUID.parameter, use: get)
    conferencesRoute.get(UUID.parameter, "divisions", use: getDivisions)
  }

  /// Returns a list of all `Conference`s.
  func index(_ req: Request) throws -> Future<[Conference]> {
    return self.repository.all()
  }

  /// Returns a specific `Conference`
  func get(_ req: Request) throws -> Future<Conference> {
    let conferenceId = try req.parameters.next(UUID.self)
    return self.repository.find(id: conferenceId)
      .unwrap(or: Abort(.notFound, reason: "Invalid conference ID"))
  }

  /// Returns the `Division` children of a specific `Conference`
  func getDivisions(_ req: Request) throws -> Future<[Division]> {
    let conferenceId = try req.parameters.next(UUID.self)
    return self.repository.find(id: conferenceId)
      .unwrap(or: Abort(.notFound, reason: "Invalid conference ID"))
      .flatMap(to: [Division].self) { conference in
        try conference.divisions.query(on: req).all()
      }
  }
}
