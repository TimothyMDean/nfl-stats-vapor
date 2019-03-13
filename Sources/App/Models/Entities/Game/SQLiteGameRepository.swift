import Vapor
import FluentSQLite

/// An implementation of the `GameRepository` protocol. using an
/// SQLite database as the backend persistence layer
struct SQLiteGameRepository: GameRepository {

  let db: SQLiteDatabase.ConnectionPool

  /// Initializes a `SQLiteGameRepository` with a specific SQLite database
  init(_ db: SQLiteDatabase.ConnectionPool) {
    self.db = db
  }

  /// Retrieves a `Game` with a specified ID, implemented using a SQLite database
  func find(id: UUID) -> Future<Game?> {
    return db.withConnection { connection in
      return Game.find(id, on: connection)
    }
  }

  /// Retrieves all `Game` entites for a week ID
  func find(weekId: UUID) -> Future<[Game]> {
    return db.withConnection { connection in
      return Game.query(on: connection).filter(\.weekId == weekId).all()
    }
  }

  /// Retrieves all `Game` entites for a season ID
  func find(seasonId: UUID) -> Future<[Game]> {
    return db.withConnection { connection in
      return Game.query(on: connection).filter(\.seasonId == seasonId).all()
    }
  }

  /// Retrieves all `Game` entities
  func all() -> Future<[Game]> {
    return db.withConnection { conn in
      return Game.query(on: conn).all()
    }
  }

  /// Saves a `Game` entity and returns the resulting (possibly changed) `Game`
  func save(game: Game) -> Future<Game> {
    return db.withConnection { conn in
      return game.save(on: conn)
    }
  }
}


/// Implements the `ServiceType` protocol for the `SQLiteGameRepository` type
extension SQLiteGameRepository {

  static let serviceSupports: [Any.Type] = [GameRepository.self]

  static func makeService(for worker: Container) throws -> SQLiteGameRepository {
    return .init(try worker.connectionPool(to: .sqlite))
  }
}


/// Adds SQLite support to the `Game` model
extension Game: SQLiteUUIDModel {}
