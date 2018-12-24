import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)

    // Routes for managing NFL conferences
    let conferenceController = ConferenceController()
    router.get("conferences", use: conferenceController.index)
    router.post("conferences", use: conferenceController.create)
    router.delete("conferences", Conference.parameter, use: conferenceController.delete)
}
