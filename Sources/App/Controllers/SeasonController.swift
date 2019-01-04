import Vapor

/// Controls basic CRUD operations on `Season`s.
final class SeasonController: RouteCollection {

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let seasonsRoute = router.grouped("seasons")
    seasonsRoute.get(use: index)
    seasonsRoute.get(Season.parameter, use: get)
    seasonsRoute.get(Season.parameter, "weeks", use: getWeeks)
    seasonsRoute.post(Season.self, use: create)
  }

  /// Returns a list of all `Season`s.
  func index(_ req: Request) throws -> Future<[Season]> {
    return Season.query(on: req).sort(\.primaryYear, .ascending).all()
  }

  /// Returns a specific `Season`
  func get(_ req: Request) throws -> Future<Season> {
    return try req.parameters.next(Season.self)
  }

  /// Creates a new `Season` and returns its URL in the `Location` header
  func create(_ req: Request, season: Season) throws -> Future<HTTPResponse> {
    return req.transaction(on: .sqlite) { connection in
      return season.save(on: connection).flatMap(to: HTTPResponse.self) { season in
        if let seasonId = season.id {
          let location = req.http.url.appendingPathComponent(season.id!.description, isDirectory: false)
          let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location.path))
          return (1...17)
            .map { Week(number:$0, seasonId: seasonId) }
            .map { $0.save(on: connection) }
            .flatten(on: connection)
            .transform(to: HTTPResponse(status: .created, headers: responseHeaders))
        } else {
          return req.future(HTTPResponse(status: .internalServerError))
        }
      }
    }
  }

  /// Returns the list of `Week` entities within a `Season` entity
  func getWeeks(_ req: Request) throws -> Future<[Week]> {
    return try req.parameters.next(Season.self).flatMap(to: [Week].self) { season in
      try season.weeks.query(on: req).sort(\.number, .ascending).all()
    }
  }
}
