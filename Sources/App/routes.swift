import Vapor

/// Register your application's routes here.
public func routes(_ router: Router, _ container: Container) throws {

  let conferenceRepository = try container.make(ConferenceRepository.self)
  let divisionRepository = try container.make(DivisionRepository.self)
  let teamRepository = try container.make(TeamRepository.self)
  let seasonRepository = try container.make(SeasonRepository.self)
  let weekRepository = try container.make(WeekRepository.self)
  let gameRepository = try container.make(GameRepository.self)

  let conferences = ConferenceController(repository: conferenceRepository)
  let divisions = DivisionController(repository: divisionRepository)
  let teams = TeamController(repository: teamRepository)
  let seasons = SeasonController(seasonRepository: seasonRepository, weekRepository: weekRepository)
  let weeks = WeekController(repository: weekRepository)
  let games = GameController(repository: gameRepository)

  try router.register(collection: conferences)
  try router.register(collection: divisions)
  try router.register(collection: teams)
  try router.register(collection: seasons)
  try router.register(collection: weeks)
  try router.register(collection: games)
}
