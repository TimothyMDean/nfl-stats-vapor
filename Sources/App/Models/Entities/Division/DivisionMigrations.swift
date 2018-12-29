import FluentSQLite
import Vapor

// A Fluent migration that seeds the Division model with AFC values
struct SeedAfcDivisions: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {

    return connection.transaction(on: .sqlite) { _ in
      return Conference.query(on: connection).filter(\.name == "AFC")
        .first()
        .flatMap(to: Void.self) { conference in
          if let cid = conference?.id {
            return Division(name: "AFC North", conferenceId: cid).save(on: connection).flatMap { _ in
              return Division(name: "AFC South", conferenceId: cid).save(on: connection).flatMap { _ in
                return Division(name: "AFC East", conferenceId: cid).save(on: connection).flatMap { _ in
                  return Division(name: "AFC West", conferenceId: cid).save(on: connection)
                }
              }
            }.map(to: Void.self) { _ in
              return
            }
          } else {
            return connection.future()
          }
        }
    }
  }

  // Performs the reversion of the migration
  static func revert(on connection: SQLiteConnection) -> Future<Void> {
    return Conference.query(on: connection).filter(\.name == "AFC")
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

    return connection.transaction(on: .sqlite) { _ in
      return Conference.query(on: connection).filter(\.name == "NFC")
        .first()
        .flatMap(to: Void.self) { conference in
          if let cid = conference?.id {
            return Division(name: "NFC North", conferenceId: cid).save(on: connection).flatMap { _ in
              return Division(name: "NFC South", conferenceId: cid).save(on: connection).flatMap { _ in
                return Division(name: "NFC East", conferenceId: cid).save(on: connection).flatMap { _ in
                  return Division(name: "NFC West", conferenceId: cid).save(on: connection)
                }
              }
            }.map(to: Void.self) { _ in
              return
            }
          } else {
            return connection.future()
          }
        }
    }
  }

  // Performs the reversion of the migration
  static func revert(on connection: SQLiteConnection) -> Future<Void> {
    return Conference.query(on: connection).filter(\.name == "NFC")
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
