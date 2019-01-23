import FluentSQLite
import Vapor

// Extends the `Season` model to implement its schema migration
extension Season: Migration {
    public static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
        }
    }
}
