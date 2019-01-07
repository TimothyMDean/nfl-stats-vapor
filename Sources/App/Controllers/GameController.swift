import Vapor

/// Controls basic CRUD operations on `Game`s.
final class GameController: RouteCollection {

  /// Registers this controxller's routes at boot time
  func boot(router: Router) throws {
    let gamesRoute = router.grouped("games")
    gamesRoute.get(Game.parameter, use: get)
  }

  /// Returns a specific `Game`
  func get(_ req: Request) throws -> Future<Game> {
    return try req.parameters.next(Game.self)
  }

  // Returns the location path that should be used for a `Game` with a specified ID
  static func location(forId gameId: Game.ID) -> String {
    return "/games/" + gameId.description
  }
}
