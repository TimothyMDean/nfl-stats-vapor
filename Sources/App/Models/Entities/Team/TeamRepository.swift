import Vapor

/// A protocl that defines the interface to a `Team` entity repository.
protocol TeamRepository : ServiceType {

  /// Retrieves a `Team` with a specified ID
  func find(id: UUID) -> Future<Team?>

  /// Retrieves all `Team` entities for a division ID
  func find(divisionId: UUID) -> Future<[Team]>

  /// Retrieves all `Team` entities for a conference ID
  func find(conferenceId: UUID) -> Future<[Team]>

  /// Retrieves all `Team` entities
  func all() -> Future<[Team]>
}
