import Vapor

/**
 API controller class for NFL Team operations.

 The methods in this class implement API endpoints that can retrieve one or all `Division`
 resources. A method is also provided to retrieve the parent `Division` and `Conference` 
 resources that are associated with a specific team.

 - Author: Tim Dean
 - Copyright: © 2019 SwizzleBits Software, Inc.
 */
final class TeamController : RouteCollection {

  private let repository: TeamRepository
  

  /**
   Initialize a new team controller instance.

   The new team controller instance must be passed a reference to a team repository
   that will be used when retrieving `Team` resources from persistent storage.

  - Parameter repository: a team repository instance
  */
  init(repository: TeamRepository) {
    self.repository = repository
  }


  /**
   Register this controller’s routes.

   A route for each supported API endpoint will be registered within a specified Vapor router
   instance. This method will create a routing group for all team endpoints and register
   its specific endpoints within that group.

   - Parameter router: a Vapor router to register routes within
   */
  func boot(router: Router) throws {
    let teamsRoute = router.grouped("teams")
    teamsRoute.get(use: index)
    teamsRoute.get(UUID.parameter, use: get)
    teamsRoute.get(UUID.parameter, "division", use: getDivision)
    teamsRoute.get(UUID.parameter, "conference", use: getConference)
  }


  /**
   Implements the index API endpoint for `Team` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list
   containing all available `Team` resources.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Team` resources
  */
  func index(_ req: Request) throws -> Future<[Team]> {
      return Team.query(on: req).all()
  }


  /**
   Implements the get API endpoint for `Team` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a specific
   `Team` resource for a team ID. The team ID will be extracted from the current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Team` resource
   - Throws: an `Abort` error if the specified team ID was invalid
   */
  func get(_ req: Request) throws -> Future<Team> {
    let teamId = try req.parameters.next(UUID.self)
    return self.repository.find(id: teamId)
      .unwrap(or: Abort(.notFound, reason: "Invalid team ID"))
  }


  /**
   Implements a get API endpoint for a `Team` resource's parent `Division` resource.

   The API endpoint implemented by this method can be used by API clients to retrieve a 
   `Division` parent resource for a team ID. The team ID will be extracted from the
   current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Division` parent resource
   - Throws: an `Abort` error if the specified team ID was invalid
   */
  func getDivision(_ req: Request) throws -> Future<Division> {
    let teamId = try req.parameters.next(UUID.self)
    return self.repository.find(id: teamId)
      .unwrap(or: Abort(.notFound, reason: "Invalid team ID"))
      .flatMap { team in
        team.division.get(on: req)
      }
  }


  /**
   Implements a get API endpoint for a `Team` resource's parent `Conference` resource.

   The API endpoint implemented by this method can be used by API clients to retrieve a 
   `Conference` parent resource for a team ID. The team ID will be extracted from the
   current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Conference` parent resource
   - Throws: an `Abort` error if the specified team ID was invalid
   */
  func getConference(_ req: Request) throws -> Future<Conference> {
    let teamId = try req.parameters.next(UUID.self)
    return self.repository.find(id: teamId)
      .unwrap(or: Abort(.notFound, reason: "Invalid team ID"))
      .flatMap { team in
        team.conference.get(on: req)
      }
  }
}
