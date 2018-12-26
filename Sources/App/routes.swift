import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // Routes for managing NFL conferences
    let conferenceController = ConferenceController()
    router.get("conferences", use: conferenceController.index)
    router.post("conferences", use: conferenceController.create)
    router.delete("conferences", Conference.parameter, use: conferenceController.delete)
}
