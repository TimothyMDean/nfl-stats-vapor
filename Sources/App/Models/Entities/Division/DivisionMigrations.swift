import FluentSQLite
import Vapor

// A Fluent migration that seeds the Division model with AFC values
struct SeedAfcDivisions: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {

    return Conference.query(on: connection).filter(\.abbreviation == "AFC")
      .first()
      .flatMap(to: Void.self) { conference in
        if let cid = conference?.id {
          return connection.transaction(on: .sqlite) { c in
            let divisions = [
              Division(name: "AFC North", conferenceId: cid),
              Division(name: "AFC South", conferenceId: cid),
              Division(name: "AFC East", conferenceId: cid),
              Division(name: "AFC West", conferenceId: cid)
            ]
            return divisions.map { $0.save(on: c) }
              .flatten(on: c)
              .transform(to: Void())
          }
        } else {
          return connection.future()
        }
      }
  }

  // Performs the reversion of the migration
  static func revert(on connection: SQLiteConnection) -> Future<Void> {
    return Conference.query(on: connection).filter(\.abbreviation == "AFC")
      .first()
      .flatMap(to: Void.self) { conference in
        if let c = conference {
          return try c.divisions.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}

// A Fluent migration that seeds the Division model with NFC values
struct SeedNfcDivisions: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {

    return Conference.query(on: connection).filter(\.abbreviation == "NFC")
      .first()
      .flatMap(to: Void.self) { conference in
        if let cid = conference?.id {
          return connection.transaction(on: .sqlite) { c in
            let divisions = [
              Division(name: "NFC North", conferenceId: cid),
              Division(name: "NFC South", conferenceId: cid),
              Division(name: "NFC East", conferenceId: cid),
              Division(name: "NFC West", conferenceId: cid)
            ]
            return divisions.map { $0.save(on: c) }
              .flatten(on: c)
              .transform(to: Void())
          }
        } else {
          return connection.future()
        }
      }
  }

  // Performs the reversion of the migration
  static func revert(on connection: SQLiteConnection) -> Future<Void> {
    return Conference.query(on: connection).filter(\.abbreviation == "NFC")
      .first()
      .flatMap(to: Void.self) { conference in
        if let c = conference {
          return try c.divisions.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}
