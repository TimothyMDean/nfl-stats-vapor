import Vapor
import FluentSQLite

// An implementation of the `ConferenceRepository` protocol. using an
// SQLite database as the backend persistence layer
struct SQLiteConferenceRepository: ConferenceRepository {

  let db: SQLiteDatabase.ConnectionPool

  // Initializes a `SQLiteConferenceRepository` with a specific SQLite database
  init(_ db: SQLiteDatabase.ConnectionPool) {
    self.db = db
  }

  // Retrieves a `Conference` with a specified ID, implemented using a SQLite database
  func find(id: UUID) -> Future<Conference?> {
    return db.withConnection { connection in
      return Conference.find(id, on: connection)
    }
  }

  // Retrieves all `Conference` entities
  func all() -> Future<[Conference]> {
    return db.withConnection { conn in
      return Conference.query(on: conn).all()
    }
  }
}


// Implements the `ServiceType` protocol for the `SQLiteConferenceRepository` type
extension SQLiteConferenceRepository {

  static let serviceSupports: [Any.Type] = [ConferenceRepository.self]

  static func makeService(for worker: Container) throws -> SQLiteConferenceRepository {
    return .init(try worker.connectionPool(to: .sqlite))
  }
}


// Adds SQLite support to the `Conference` model
extension Conference: SQLiteUUIDModel {}
