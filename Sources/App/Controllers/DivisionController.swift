import Vapor

/**
 API controller class for NFL Division operations.

 The methods in this class implement API endpoints that can retrieve one or all `Division`
 resources. A method is also provided to retrieve the parent `Conference` and child `Team` 
 resources that are associated with a specific division.

 - Author: Tim Dean
 - Copyright: © 2019 SwizzleBits Software, Inc.
 */
final class DivisionController : RouteCollection {

  private let repository: DivisionRepository


  /**
   Initialize a new division controller instance.

   The new division controller instance must be passed a reference to a division repository
   that will be used when retrieving `Division` resources from persistent storage.

  - Parameter repository: a division repository instance
  */
  init(repository: DivisionRepository) {
    self.repository = repository
  }


  /**
   Register this controller’s routes.

   A route for each supported API endpoint will be registered within a specified Vapor router
   instance. This method will create a routing group for all division endpoints and register
   its specific endpoints within that group.

   - Parameter router: a Vapor router to register routes within
   */
  func boot(router: Router) throws {
    let divisionsRoute = router.grouped("divisions")
    divisionsRoute.get(use: index)
    divisionsRoute.get(UUID.parameter, use: get)
    divisionsRoute.get(UUID.parameter, "conference", use: getConference)
    divisionsRoute.get(UUID.parameter, "teams", use: getTeams)
  }


  /**
   Implements the index API endpoint for `Division` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list
   containing all available `Division` resources.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Division` resources
  */
  func index(_ req: Request) throws -> Future<[Division]> {
      return Division.query(on: req).all()
  }


  /**
   Implements the get API endpoint for `Division` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a specific
   `Division` resource for a division ID. The division ID will be extracted from the current
   API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Division` resource
   - Throws: an `Abort` error if the specified division ID was invalid
   */
  func get(_ req: Request) throws -> Future<Division> {
    let divisionId = try req.parameters.next(UUID.self)
    return self.repository.find(id: divisionId)
      .unwrap(or: Abort(.notFound, reason: "Invalid division ID"))
  }


  /**
   Implements a get API endpoint for a `Division` resource's parent `Conference` resource.

   The API endpoint implemented by this method can be used by API clients to retrieve a 
   `Conference` parent resource for a division ID. The division ID will be extracted from the
   current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Conference` parent resource
   - Throws: an `Abort` error if the specified division ID was invalid
   */
  func getConference(_ req: Request) throws -> Future<Conference> {
    let divisionId = try req.parameters.next(UUID.self)
    return self.repository.find(id: divisionId)
      .unwrap(or: Abort(.notFound, reason: "Invalid division ID"))
      .flatMap { division in
        division.conference.get(on: req)
      }
  }


  /**
   Implements a get API endpoint for a `Division` resource's child `Team` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list of
   `Team` child resources for a division ID. The division ID will be extracted from the
   current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Team` child resources
   - Throws: an `Abort` error if the specified division ID was invalid
   */
  func getTeams(_ req: Request) throws -> Future<[Team]> {
    let divisionId = try req.parameters.next(UUID.self)
    return self.repository.find(id: divisionId)
      .unwrap(or: Abort(.notFound, reason: "Invalid division ID"))
      .flatMap { division in
        try division.teams.query(on: req).all()
      }
  }
}
