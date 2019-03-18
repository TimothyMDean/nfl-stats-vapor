import Vapor

// A protocol that defines the interface to a `Season` entity repository.
protocol SeasonRepository : ServiceType {

  // Retrieves a `Season` with a specified ID
  func find(id: UUID) -> Future<Season?>

  // Retrieves all `Season` entities
  func all() -> Future<[Season]>

  // Saves a `Season` entity and returns the resulting (possibly changed) `Season`
  func save(season: Season) -> Future<Season>
}
