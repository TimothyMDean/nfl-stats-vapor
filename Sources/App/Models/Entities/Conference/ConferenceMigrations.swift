import FluentSQLite
import Vapor

// A Fluent migration that seeds the Conference model with initial values
struct SeedConferences: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    let afc = Conference(name: "AFC", assetPrefix: "afc")
    let nfc = Conference(name: "NFC", assetPrefix: "nfc")
    return connection.transaction(on: .sqlite) { _ in
      return afc.save(on: connection).flatMap { _ in
        return nfc.save(on: connection)
      }.map(to: Void.self) {_ in return}
    }
  }

  // Performs the reversion of the migration
  static func revert(on connection: SQLiteConnection) -> Future<Void> {
    return Conference.query(on: connection).delete()
  }
}
