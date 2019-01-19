import Vapor

// A protocol that defines the interface to a `Division` entity repository.
protocol DivisionRepository: ServiceType {

  // Retrieves a `Division` with a specified ID
  func find(id: UUID) -> Future<Division?>

  // Retrieves all `Division` entites for a conference ID
  func find(conferenceId: UUID) -> Future<[Division]>

  // Retrieves all `Division` entities
  func all() -> Future<[Division]>
}
