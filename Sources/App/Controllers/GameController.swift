import Vapor

/**
 API controller class for NFL Game operations.

 The methods in this class implement API endpoints that can retrieve one or all `Game`
 resources. A method is also provided to retrieve the parent `Week` resource that
 is associated with a specific game.

 - Author: Tim Dean
 - Copyright: © 2019 SwizzleBits Software, Inc.
 */
final class GameController : RouteCollection {

  private let repository: GameRepository


  /**
   Initialize a new game controller instance.

   The new game controller instance must be passed a reference to a game repository
   that will be used when retrieving `Game` resources from persistent storage.

  - Parameter repository: a game repository instance
  */
  init(repository: GameRepository) {
    self.repository = repository
  }


  /**
   Register this controller’s routes.

   A route for each supported API endpoint will be registered within a specified Vapor router
   instance. This method will create a routing group for all game endpoints and register
   its specific endpoints within that group.

   - Parameter router: a Vapor router to register routes within
   */
  func boot(router: Router) throws {
    let gamesRoute = router.grouped("games")
    gamesRoute.get(use: index)
    gamesRoute.get(UUID.parameter, use: get)
  }
  

  /**
   Implements the index API endpoint for `Game` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list
   containing all available `Game` resources.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Game` resources
  */
  func index(_ req: Request) throws -> Future<[Game]> {
    return self.repository.all()
  }


  /**
   Implements the get API endpoint for `Game` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a specific
   `Game` resource for a game ID. The game ID will be extracted from the current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Game` resource
   - Throws: an `Abort` error if the specified game ID was invalid
   */
  func get(_ req: Request) throws -> Future<Game> {
    let gameId = try req.parameters.next(UUID.self)
    return self.repository.find(id: gameId)
      .unwrap(or: Abort(.notFound, reason: "Invalid Game ID"))
  }


  /**
   Computes the location value to use for a game with a specified ID.

   - Parameter gameId: the ID for the game
   - Returns: a location string
   */
  static func location(forId gameId: Game.ID) -> String {
    return "/games/" + gameId.description
  }
}
