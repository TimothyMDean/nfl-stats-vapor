import Vapor
import FluentSQLite

/// An implementation of the `WeekRepository` protocol. using an
/// SQLite database as the backend persistence layer
struct SQLiteWeekRepository: WeekRepository {

  let db: SQLiteDatabase.ConnectionPool

  /// Initializes a `SQLiteWeekRepository` with a specific SQLite database
  init(_ db: SQLiteDatabase.ConnectionPool) {
    self.db = db
  }

  /// Retrieves a `Week` with a specified ID, implemented using a SQLite database
  func find(id: UUID) -> Future<Week?> {
    return db.withConnection { connection in
      return Week.find(id, on: connection)
    }
  }

  /// Retrieves all `Week` entites for a season ID
  func find(seasonId: UUID) -> Future<[Week]> {
    return db.withConnection { connection in
      return Week.query(on: connection).filter(\.seasonId == seasonId).all()
    }
  }

  /// Retrieves all `Week` entities
  func all() -> Future<[Week]> {
    return db.withConnection { conn in
      return Week.query(on: conn).all()
    }
  }

  /// Saves a `Week` entity and returns the resulting (possibly changed) `Week`
  func save(week: Week) -> Future<Week> {
    return db.withConnection { conn in
      return week.save(on: conn)
    }
  }
}


// Implements the `ServiceType` protocol for the `SQLiteWeekRepository` type
extension SQLiteWeekRepository {

  static let serviceSupports: [Any.Type] = [WeekRepository.self]

  static func makeService(for worker: Container) throws -> SQLiteWeekRepository {
    return .init(try worker.connectionPool(to: .sqlite))
  }
}


// Adds SQLite support to the `Week` model
extension Week: SQLiteUUIDModel {}
