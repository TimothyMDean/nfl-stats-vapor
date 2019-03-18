import Vapor
import FluentSQLite

// An implementation of the `TeamRepository` protocol. using an
// SQLite database as the backend persistence layer
struct SQLiteTeamRepository : TeamRepository {

  let db: SQLiteDatabase.ConnectionPool

  // Initializes a `SQLiteTeamRepository` with a specific SQLite database
  init(_ db: SQLiteDatabase.ConnectionPool) {
    self.db = db
  }

  // Retrieves a `Team` with a specified ID, implemented using a SQLite database
  func find(id: UUID) -> Future<Team?> {
    return db.withConnection { connection in
      return Team.find(id, on: connection)
    }
  }

  // Retrieves all `Team` entites for a conference ID
  func find(conferenceId: UUID) -> Future<[Team]> {
    return db.withConnection { connection in
      return Team.query(on: connection).filter(\.conferenceId == conferenceId).all()
    }
  }

  // Retrieves all `Team` entites for a division ID
  func find(divisionId: UUID) -> Future<[Team]> {
    return db.withConnection { connection in
      return Team.query(on: connection).filter(\.divisionId == divisionId).all()
    }
  }

  // Retrieves all `Team` entities
  func all() -> Future<[Team]> {
    return db.withConnection { conn in
      return Team.query(on: conn).all()
    }
  }
}


// Implements the `ServiceType` protocol for the `SQLiteTeamRepository` type
extension SQLiteTeamRepository {

  static let serviceSupports: [Any.Type] = [TeamRepository.self]

  static func makeService(for worker: Container) throws -> SQLiteTeamRepository {
    return .init(try worker.connectionPool(to: .sqlite))
  }
}


// Adds SQLite support to the `Team` model
extension Team : SQLiteUUIDModel {}
