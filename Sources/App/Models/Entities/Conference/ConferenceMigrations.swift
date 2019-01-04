import FluentSQLite
import Vapor

// A Fluent migration that seeds the Conference model with initial values
struct SeedConferences: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return connection.transaction(on: .sqlite) { c in
      let conferences = [
        Conference(name: "American Football Conference", abbreviation: "AFC"),
        Conference(name: "National Football Conference", abbreviation: "NFC")
      ]
      return conferences.map {$0.save(on: c)}.flatten(on: c).transform(to: Void())
    }
  }

  // Performs the reversion of the migration
  static func revert(on connection: SQLiteConnection) -> Future<Void> {
    return Conference.query(on: connection).delete()
  }
}
