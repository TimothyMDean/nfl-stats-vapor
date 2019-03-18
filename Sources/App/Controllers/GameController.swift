import Vapor

/// Controls basic CRUD operations on `Game`s.
final class GameController : RouteCollection {

  private let repository: GameRepository

  /// Initialize a new `GameController`
  init(repository: GameRepository) {
    self.repository = repository
  }

  /// Registers this controller’s routes at boot time
  func boot(router: Router) throws {
    let gamesRoute = router.grouped("games")
    gamesRoute.get(use: index)
    gamesRoute.get(UUID.parameter, use: get)
  }

  /// Returns a list of all `Game`s.
  func index(_ req: Request) throws -> Future<[Game]> {
    return self.repository.all()
  }

  /// Returns a specific `Game`
  func get(_ req: Request) throws -> Future<Game> {
    let gameId = try req.parameters.next(UUID.self)
    return self.repository.find(id: gameId)
      .unwrap(or: Abort(.notFound, reason: "Invalid Game ID"))
  }

  // Returns the location path that should be used for a `Game` with a specified ID
  static func location(forId gameId: Game.ID) -> String {
    return "/games/" + gameId.description
  }
}
