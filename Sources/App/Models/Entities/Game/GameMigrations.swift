import FluentSQLite
import Vapor

// Extends the `Game` model to implement its schema migration
extension Game: Migration {
    public static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
        }
    }
}
