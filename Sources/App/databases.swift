import Vapor
import FluentSQLite

// Adds databases to the Vapor databases configuration
public func databases(config: inout DatabasesConfig) throws {
  let sqlite = try SQLiteDatabase(storage: .memory)
  config.add(database: sqlite, as: .sqlite)
}

// Defines a connection pool type alias within the `Database` protocol
extension Database {
    public typealias ConnectionPool = DatabaseConnectionPool<ConfiguredDatabase<Self>>
}
