import Vapor

/// A protocol that defines the interface to a `Week` entity repository.
protocol WeekRepository : ServiceType {

  /// Retrieves a `Week` with a specified ID
  func find(id: UUID) -> Future<Week?>

  /// Retrieves all `Week` entities for a season ID
  func find(seasonId: UUID) -> Future<[Week]>

  /// Retrieves all `Week` entities
  func all() -> Future<[Week]>

  /// Saves a `Week` entity and returns the resulting (possibly changed) `Week`
  func save(week: Week) -> Future<Week>
}
