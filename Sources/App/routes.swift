import Vapor

/// Register your application's routes here.
public func routes(_ router: Router, _ container: Container) throws {

  let conferenceRepository = try container.make(ConferenceRepository.self)
  try router.register(collection: ConferenceController(repository: conferenceRepository))

  try router.register(collection: DivisionController())
  try router.register(collection: TeamController())
  try router.register(collection: SeasonController())
  try router.register(collection: WeekController())
  try router.register(collection: GameController())
}
