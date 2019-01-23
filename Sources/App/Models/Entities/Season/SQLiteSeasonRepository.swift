import Vapor
import FluentSQLite

// An implementation of the `SeasonRepository` protocol. using an
// SQLite database as the backend persistence layer
struct SQLiteSeasonRepository: SeasonRepository {

  let db: SQLiteDatabase.ConnectionPool

  // Initializes a `SQLiteSeasonRepository` with a specific SQLite database
  init(_ db: SQLiteDatabase.ConnectionPool) {
    self.db = db
  }

  // Retrieves a `Season` with a specified ID, implemented using a SQLite database
  func find(id: UUID) -> Future<Season?> {
    return db.withConnection { connection in
      return Season.find(id, on: connection)
    }
  }

  // Retrieves all `Season` entities
  func all() -> Future<[Season]> {
    return db.withConnection { conn in
      return Season.query(on: conn).all()
    }
  }

  // Saves a `Season` entity and returns the resulting (possibly changed) `Season`
  func save(season: Season) -> Future<Season> {
    return db.withConnection { conn in
      return season.save(on: conn)
    }
  }
}


// Implements the `ServiceType` protocol for the `SQLiteSeasonRepository` type
extension SQLiteSeasonRepository {

  static let serviceSupports: [Any.Type] = [SeasonRepository.self]

  static func makeService(for worker: Container) throws -> SQLiteSeasonRepository {
    return .init(try worker.connectionPool(to: .sqlite))
  }
}


// Adds SQLite support to the `Season` model
extension Season: SQLiteUUIDModel {}
