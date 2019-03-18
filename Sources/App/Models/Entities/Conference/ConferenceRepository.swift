import Vapor

// A protocol that defines the interface to a `Conference` entity repository.
protocol ConferenceRepository : ServiceType {

  // Retrieves a `Conference` with a specified ID
  func find(id: UUID) -> Future<Conference?>

  // Retrieves all `Conference` entities
  func all() -> Future<[Conference]>
}
