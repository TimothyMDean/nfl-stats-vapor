import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    try router.register(collection: ConferenceController())
    try router.register(collection: DivisionController())
    try router.register(collection: TeamController())
    try router.register(collection: SeasonController())
    try router.register(collection: WeekController())
}
