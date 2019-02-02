import FluentSQLite
import Vapor

// Extends the `Week` model to implement its schema migration
extension Week: Migration {
    public static func prepare(on connection: SQLiteConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
        }
    }
}
