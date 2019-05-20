import Vapor

/**
 API controller class for NFL Conference operations.

 The methods in this class implement API endpoints that can retrieve one or all `Conference`
 resources. A method is also provided to retrieve the child `Division` resources that are
 associated with a specific conference.

 - Author: Tim Dean
 - Copyright: © 2019 SwizzleBits Software, Inc.
 */
final class ConferenceController : RouteCollection {

  private let repository: ConferenceRepository


  /**
   Initialize a new conference controller instance.

   The new conference controller instance must be passed a reference to a conference repository
   that will be used when retrieving `Conference` resources from persistent storage.

  - Parameter repository: a conference repository instance
  */
  init(repository: ConferenceRepository) {
    self.repository = repository
  }


  /**
   Register this controller’s routes.

   A route for each supported API endpoint will be registered within a specified Vapor router
   instance. This method will create a routing group for all conference endpoints and register
   its specific endpoints within that group.

   - Parameter router: a Vapor router to register routes within
   */
  func boot(router: Router) throws {
    let conferencesRoute = router.grouped("conferences")
    conferencesRoute.get(use: index)
    conferencesRoute.get(UUID.parameter, use: get)
    conferencesRoute.get(UUID.parameter, "divisions", use: getDivisions)
  }


  /**
   Implements the index API endpoint for `Conference` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list
   containing all available `Conference` resources.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Conference` resources
  */
  func index(_ req: Request) -> Future<[Conference]> {
    return self.repository.all()
  }


  /**
   Implements the get API endpoint for `Conference` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a specific
   `Conference` resource for a conference ID. The conference ID will be extracted from the current
   API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future `Conference` resource
   - Throws: an `Abort` error if the specified conference ID was invalid
   */
  func get(_ req: Request) throws -> Future<Conference> {
    let conferenceId = try req.parameters.next(UUID.self)
    return self.repository.find(id: conferenceId)
      .unwrap(or: Abort(.notFound, reason: "Invalid conference ID"))
  }


  /**
   Implements a get API endpoint for a `Conference` resource's child `Division` resources.

   The API endpoint implemented by this method can be used by API clients to retrieve a list of
   `Division` child resources for a conference ID. The conference ID will be extracted from the
   current API request.

   - Parameter req: the API request currently being serviced
   - Returns: a future array of `Division` child resources
   - Throws: an `Abort` error if the specified conference ID was invalid
   */
  func getDivisions(_ req: Request) throws -> Future<[Division]> {
    let conferenceId = try req.parameters.next(UUID.self)
    return self.repository.find(id: conferenceId)
      .unwrap(or: Abort(.notFound, reason: "Invalid conference ID"))
      .flatMap(to: [Division].self) { conference in
        try conference.divisions.query(on: req).all()
      }
  }
}
