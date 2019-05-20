import Vapor

/**
 API controller class for NFL Season operations.

 The methods in this class implement API endpoints that can retrieve one or all `Season`
 resources. A method is also provided to retrieve the child `Week` resources that are
 associated with a specific season.

 - Author: Tim Dean
 - Copyright: © 2019 SwizzleBits Software, Inc.
 */
final class SeasonController : RouteCollection {

  private let seasonRepository: SeasonRepository
  private let weekRepository: WeekRepository


  /**
   Initialize a new season controller instance.

   The new season controller instance must be passed a reference to a season repository
   that will be used when retrieving `Season` resources from persistent storage.

  - Parameter repository: a season repository instance
  */
  init(seasonRepository: SeasonRepository, weekRepository: WeekRepository) {
    self.seasonRepository = seasonRepository
    self.weekRepository = weekRepository
  }


  /**
   Register this controller’s routes.

   A route for each supported API endpoint will be registered within a specified Vapor router
   instance. This method will create a routing group for all season endpoints and register
   its specific endpoints within that group.

   - Parameter router: a Vapor router to register routes within
   */
  func boot(router: Router) throws {
    let seasonsRoute = router.grouped("seasons")
    seasonsRoute.get(use: index)
    seasonsRoute.get(UUID.parameter, use: get)
    seasonsRoute.get(UUID.parameter, "weeks", use: getWeeks)
    seasonsRoute.get(UUID.parameter, "games", use: getGames)
    seasonsRoute.post(Season.self, use: create)
  }


  /**
   Implements the index API endpoint for `Season` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list
   containing all available `Season` resources.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Season` resources
  */
  func index(_ req: Request) throws -> Future<[Season]> {
    return self.seasonRepository.all()
  }


  /**
   Implements the get API endpoint for `Season` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a specific
   `Season` resource for a season ID. The season ID will be extracted from the current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Season` resource
   - Throws: an `Abort` error if the specified season ID was invalid
   */
  func get(_ req: Request) throws -> Future<Season> {
    let seasonId = try req.parameters.next(UUID.self)
    return self.seasonRepository.find(id: seasonId)
      .unwrap(or: Abort(.notFound, reason: "Invalid season ID"))
  }


  /// Creates a new `Season` and returns its URL in the `Location` header
  /**
   Implements the creation API endpoint for the `Season` resources.

   The API endpoint implemented by this method can be used by API clients to create a new
   `Season` resource. The season contents from the request body are passed as an argument.

   - Parameters:
       - req: The API request currently being serviced
       - season: The contents of the new season
   - Returns: a future HTTP response containing a `Location` header
   - Throws: an `Abort` error if the specified session was invalid
   */
  func create(_ req: Request, season: Season) throws -> Future<HTTPResponse> {
    return req.transaction(on: .sqlite) { connection in
      return self.seasonRepository.save(season: season).flatMap(to: HTTPResponse.self) { season in
        guard let seasonId = season.id else { throw Abort(.internalServerError, reason: "Missing season ID") }
        let location = SeasonController.location(forId: seasonId)
        let responseHeaders = HTTPHeaders(dictionaryLiteral: ("Location", location))
        return (1...17)
          .map { Week(number: $0, seasonId: seasonId) }
          .map { self.weekRepository.save(week: $0) }
          .flatten(on: connection)
          .transform(to: HTTPResponse(status: .created, headers: responseHeaders))
      }
    }
  }

  /**
   Implements a get API endpoint for a `Season` resource's child `Week` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list of
   `Week` child resources for a season ID. The season ID will be extracted from the
   current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Week` child resources
   - Throws: an `Abort` error if the specified season ID was invalid
   */
  func getWeeks(_ req: Request) throws -> Future<[Week]> {
    let seasonId = try req.parameters.next(UUID.self)
    return self.seasonRepository.find(id: seasonId)
      .unwrap(or: Abort(.notFound, reason: "Invalid season ID"))
      .flatMap(to: [Week].self) { season in
        try season.weeks.query(on: req).all()
      }
  }


  /**
   Implements a get API endpoint for a `Season` resource's child `Game` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list 
   of `Game` child resources for a season ID. The season ID will be extracted from the
   current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Week` child resources
   - Throws: an `Abort` error if the specified season ID was invalid
   */
  func getGames(_ req: Request) throws -> Future<[Game]> {
    let seasonId = try req.parameters.next(UUID.self)
    return self.seasonRepository.find(id: seasonId)
      .unwrap(or: Abort(.notFound, reason: "Invalid season ID"))
      .flatMap(to: [Game].self) { season in
        try season.games.query(on: req).all()
      }
  }


  /**
   Computes the location value to use for a season with a specified ID.

   - Parameter seasonId: the ID for the season
   - Returns: a location string
   */
  static func location(forId seasonId: Season.ID) -> String {
    return "/seasons/" + seasonId.description
  }
}
