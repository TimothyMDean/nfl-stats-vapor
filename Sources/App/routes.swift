import Vapor

/// Register your application's routes here.
public func routes(_ router: Router, _ container: Container) throws {

  let conferenceRepository = try container.make(ConferenceRepository.self)
  try router.register(collection: ConferenceController(repository: conferenceRepository))

  let divisionRepository = try container.make(DivisionRepository.self)
  try router.register(collection: DivisionController(repository: divisionRepository))

  try router.register(collection: TeamController())
  try router.register(collection: SeasonController())
  try router.register(collection: WeekController())
  try router.register(collection: GameController())
}
