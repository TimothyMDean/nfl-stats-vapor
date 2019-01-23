import Vapor

/// Register your application's routes here.
public func routes(_ router: Router, _ container: Container) throws {

  let conferenceRepository = try container.make(ConferenceRepository.self)
  try router.register(collection: ConferenceController(repository: conferenceRepository))

  let divisionRepository = try container.make(DivisionRepository.self)
  try router.register(collection: DivisionController(repository: divisionRepository))

  let teamRepository = try container.make(TeamRepository.self)
  try router.register(collection: TeamController(repository: teamRepository))

  let seasonRepository = try container.make(SeasonRepository.self)
  try router.register(collection: SeasonController(repository: seasonRepository))
  
  try router.register(collection: WeekController())
  try router.register(collection: GameController())
}
