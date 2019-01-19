import Vapor
import FluentSQLite

// An implementation of the `DivisionRepository` protocol. using an
// SQLite database as the backend persistence layer
struct SQLiteDivisionRepository: DivisionRepository {

  let db: SQLiteDatabase.ConnectionPool

  // Initializes a `SQLiteDivisionRepository` with a specific SQLite database
  init(_ db: SQLiteDatabase.ConnectionPool) {
    self.db = db
  }

  // Retrieves a `Division` with a specified ID, implemented using a SQLite database
  func find(id: UUID) -> Future<Division?> {
    return db.withConnection { connection in
      return Division.find(id, on: connection)
    }
  }

  // Retrieves all `Division` entites for a conference ID
  func find(conferenceId: UUID) -> Future<[Division]> {
    return db.withConnection { connection in
      return Division.query(on: connection).filter(\.conferenceId == conferenceId).all()
    }
  }

  // Retrieves all `Division` entities
  func all() -> Future<[Division]> {
    return db.withConnection { conn in
      return Division.query(on: conn).all()
    }
  }
}


// Implements the `ServiceType` protocol for the `SQLiteDivisionRepository` type
extension SQLiteDivisionRepository {

  static let serviceSupports: [Any.Type] = [DivisionRepository.self]

  static func makeService(for worker: Container) throws -> SQLiteDivisionRepository {
    return .init(try worker.connectionPool(to: .sqlite))
  }
}


// Adds SQLite support to the `Division` model
extension Division: SQLiteUUIDModel {}
