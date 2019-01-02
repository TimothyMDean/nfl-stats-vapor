import Vapor

/// Controls basic CRUD operations on `Season`s.
final class SeasonController: RouteCollection {

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let seasonsRoute = router.grouped("seasons")
    seasonsRoute.get(use: index)
    seasonsRoute.get(Season.parameter, use: get)
    seasonsRoute.post(Season.self, use: create)
  }

  /// Returns a list of all `Season`s.
  func index(_ req: Request) throws -> Future<[Season]> {
    return Season.query(on: req).all()
  }

  /// Returns a specific `Season`
  func get(_ req: Request) throws -> Future<Season> {
    return try req.parameters.next(Season.self)
  }

  /// Creates a new `Season` and returns its URL in the `Location` header
  func create(_ req: Request, season: Season) throws -> Future<HTTPResponse> {
    return season.save(on: req).map(to: HTTPResponse.self) { season in
      let location = req.http.url.appendingPathComponent(season.id!.description, isDirectory: false)
      let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location.path))
      return HTTPResponse(status: .created, headers: responseHeaders)
    }
  }
}
