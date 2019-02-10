import Vapor

/// A protocol that defines the interface to a `Game` entity repository.
protocol GameRepository: ServiceType {

  /// Retrieves a `Game` with a specified ID
  func find(id: UUID) -> Future<Game?>

  /// Retrieves all `Game` entities for a week ID
  func find(weekId: UUID) -> Future<[Game]>

  /// Retrieves all `Game` entities
  func all() -> Future<[Game]>

  /// Saves a `Game` entity and returns the resulting (possibly changed) `Game`
  func save(game: Game) -> Future<Game>
}
