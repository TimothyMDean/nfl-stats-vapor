import Vapor

/**
 API controller class for NFL Week operations.

 The methods in this class implement API endpoints that can retrieve one or all `Week`
 resources. A method is also provided to retrieve the parent `Season` and child `Game` 
 resources that are associated with a specific week.

 - Author: Tim Dean
 - Copyright: © 2019 SwizzleBits Software, Inc.
 */
final class WeekController : RouteCollection {

  private let repository: WeekRepository


  /**
   Initialize a new week controller instance.

   The new week controller instance must be passed a reference to a week repository
   that will be used when retrieving `Week` resources from persistent storage.

  - Parameter repository: a week repository instance
  */
  init(repository: WeekRepository) {
    self.repository = repository
  }


  /**
   Register this controller’s routes.

   A route for each supported API endpoint will be registered within a specified Vapor router
   instance. This method will create a routing group for all week endpoints and register
   its specific endpoints within that group.

   - Parameter router: a Vapor router to register routes within
   */
  func boot(router: Router) throws {
    let weeksRoute = router.grouped("weeks")
    weeksRoute.get(use: index)
    weeksRoute.get(UUID.parameter, use: get)
    weeksRoute.get(UUID.parameter, "games", use: getGames)
    weeksRoute.post(Week.self, use: create)
    weeksRoute.post(CreateGameRequest.self, at: UUID.parameter, "games", use: createGame)
  }


  /**
   Implements the index API endpoint for `Week` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list
   containing all available `Week` resources.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Week` resources
  */
  func index(_ req: Request) throws -> Future<[Week]> {
    return self.repository.all()
  }


  /**
   Implements the get API endpoint for `Week` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a specific
   `Week` resource for a week ID. The week ID will be extracted from the current
   API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Week` resource
   - Throws: an `Abort` error if the specified week ID was invalid
   */
  func get(_ req: Request) throws -> Future<Week> {
    let weekId = try req.parameters.next(UUID.self)
    return self.repository.find(id: weekId)
      .unwrap(or: Abort(.notFound, reason: "Invalid week ID"))
  }


  /**
   Implements the creation API endpoint for `Week` resources.

   The API endpoint implemented by this method can be used by API clients to create a new
   `Week` resource. The week contents from the request body are passed as an argument.

   - Parameters:
       - req: The API request currently being serviced
       - week: The contents of the new week
   - Returns: a future HTTP response containing a `Location` header
   - Throws: an `Abort` error if the specified session was invalid
   */
  func create(_ req: Request, week: Week) throws -> Future<HTTPResponse> {
    return req.transaction(on: .sqlite) { connection in
      return self.repository.save(week: week).map(to: HTTPResponse.self) { week in
        guard let weekId = week.id else { throw Abort(.internalServerError, reason: "Missing week ID") }
        let location = WeekController.location(forId: weekId)
        let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location))
        return HTTPResponse(status: .created, headers: responseHeaders)
      }
    }
  }


  /**
   Implements a get API endpoint for a `Week` resource's child `Game` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list of
   `Game` child resources for a week ID. The week ID will be extracted from the current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Game` child resources
   - Throws: an `Abort` error if the specified week ID was invalid
   */
  func getGames(_ req: Request) throws -> Future<[Game]> {
    let weekId = try req.parameters.next(UUID.self)
    return self.repository.find(id: weekId)
      .unwrap(or: Abort(.notFound, reason: "Invalid week ID"))
      .flatMap(to: [Game].self) { week in
        try week.games.query(on: req).all()
      }
  }


  /**
   Implements the creation API endpoint for `Game` resources within a `Week` resource.

   The API endpoint implemented by this method can be used by API clients to create a new
   `Game` resource. The game contents from the request body are passed as an argument.

   - Parameters:
       - req: The API request currently being serviced
       - week: The contents of the new week
   - Returns: a future HTTP response containing a `Location` header
   - Throws: an `Abort` error if the specified session was invalid
   */
  func createGame(_ req: Request, gameRequest: CreateGameRequest) throws -> Future<HTTPResponse> {
    let weekId = try req.parameters.next(UUID.self)
    return self.repository.find(id: weekId)
      .unwrap(or: Abort(.notFound, reason: "Invalid week ID"))
      .flatMap(to: HTTPResponse.self) { week in
        let newGame = Game(
          scheduledTime: gameRequest.scheduledTime,
          homeTeamId: gameRequest.homeTeamId,
          awayTeamId: gameRequest.awayTeamId,
          weekId: weekId,
          seasonId: week.seasonId)
        return newGame.save(on: req).map(to: HTTPResponse.self) { game in
          guard let gameId = game.id else { throw Abort(.internalServerError, reason: "Missing game ID") }
          let location = GameController.location(forId: gameId)
          let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location))
          return HTTPResponse(status: .created, headers: responseHeaders)
        }
      }
  }


  /**
   Computes the location value to use for a week with a specified ID.

   - Parameter weekId: the ID for the week
   - Returns: a location string
   */
  static func location(forId weekId: Week.ID) -> String {
    return "/weeks/" + weekId.description
  }
}
