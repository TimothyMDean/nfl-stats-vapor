import Vapor

/// Controls basic CRUD operations on `Game`s.
final class GameController: RouteCollection {

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let gamesRoute = router.grouped("games")
    gamesRoute.get(Game.parameter, use: get)
    gamesRoute.post(Game.self, use: create)
  }

  /// Returns a specific `Game`
  func get(_ req: Request) throws -> Future<Game> {
    return try req.parameters.next(Game.self)
  }

  /// Creates a new `Game` and returns its URL in the `Location` header
  func create(_ req: Request, game: Game) throws -> Future<HTTPResponse> {
    return game.save(on: req).flatMap(to: HTTPResponse.self) { game in
      if let gameId = game.id {
        let location = req.http.url.appendingPathComponent(gameId.description, isDirectory: false)
        let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location.path))
        return req.future(HTTPResponse(status: .created, headers: responseHeaders))
      } else {
        return req.future(HTTPResponse(status: .internalServerError))
      }
    }
  }
}
