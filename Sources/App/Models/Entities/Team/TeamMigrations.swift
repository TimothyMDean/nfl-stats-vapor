import FluentSQLite
import Vapor

// Extends the `Team` model to implement its schema migration
extension Team : Migration {
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
      try addProperties(to: builder)
      builder.reference(from: \.divisionId, to: \Division.id)
    }
  }
}

// A Fluent migration that seeds the Team model with AFC North values
struct SeedAfcNorthTeams : SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "AFC North")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id, let cid = division?.conferenceId {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Baltimore Ravens", abbreviation: "BAL", conferenceId: cid, divisionId: did),
              Team(name: "Cincinnati Bengals", abbreviation: "CIN", conferenceId: cid, divisionId: did),
              Team(name: "Cleveland Browns", abbreviation: "CLE", conferenceId: cid, divisionId: did),
              Team(name: "Pittsburgh Steelers", abbreviation: "PIT", conferenceId: cid, divisionId: did)
            ]
            return teams.map { $0.save(on: c) }
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
    return Division.query(on: connection).filter(\.name == "AFC North")
      .first()
      .flatMap(to: Void.self) { division in
        if let d = division {
          return try d.teams.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}

// A Fluent migration that seeds the Team model with AFC South values
struct SeedAfcSouthTeams : SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "AFC South")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id, let cid = division?.conferenceId {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Houston Texans", abbreviation: "HOU", conferenceId: cid, divisionId: did),
              Team(name: "Indianapolis Colts", abbreviation: "IND", conferenceId: cid, divisionId: did),
              Team(name: "Jacksonville Jaguars", abbreviation: "JAX", conferenceId: cid, divisionId: did),
              Team(name: "Tennessee Titans", abbreviation: "TEN", conferenceId: cid, divisionId: did)
            ]
            return teams.map { $0.save(on: c) }
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
    return Division.query(on: connection).filter(\.name == "AFC South")
      .first()
      .flatMap(to: Void.self) { division in
        if let d = division {
          return try d.teams.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}

// A Fluent migration that seeds the Team model with AFC East values
struct SeedAfcEastTeams : SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "AFC East")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id, let cid = division?.conferenceId {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Buffalo Bills", abbreviation: "BUF", conferenceId: cid, divisionId: did),
              Team(name: "Miami Dolphins", abbreviation: "MIA", conferenceId: cid, divisionId: did),
              Team(name: "New England Patriots", abbreviation: "NE", conferenceId: cid, divisionId: did),
              Team(name: "New York Jets", abbreviation: "NYJ", conferenceId: cid, divisionId: did)
            ]
            return teams.map { $0.save(on: c) }
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
    return Division.query(on: connection).filter(\.name == "AFC East")
      .first()
      .flatMap(to: Void.self) { division in
        if let d = division {
          return try d.teams.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}

// A Fluent migration that seeds the Team model with AFC West values
struct SeedAfcWestTeams : SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "AFC West")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id, let cid = division?.conferenceId {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Denver Broncos", abbreviation: "DEN", conferenceId: cid, divisionId: did),
              Team(name: "Kansas City Chiefs", abbreviation: "KC", conferenceId: cid, divisionId: did),
              Team(name: "Los Angeles Chargers", abbreviation: "LAC", conferenceId: cid, divisionId: did),
              Team(name: "Oakland Raiders", abbreviation: "OAK", conferenceId: cid, divisionId: did)
            ]
            return teams.map { $0.save(on: c) }
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
    return Division.query(on: connection).filter(\.name == "AFC West")
      .first()
      .flatMap(to: Void.self) { division in
        if let d = division {
          return try d.teams.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}

// A Fluent migration that seeds the Team model with NFC North values
struct SeedNfcNorthTeams : SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "NFC North")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id, let cid = division?.conferenceId {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Chicago Bears", abbreviation: "CHI", conferenceId: cid, divisionId: did),
              Team(name: "Detroit Lions", abbreviation: "DET", conferenceId: cid, divisionId: did),
              Team(name: "Green Bay Packers", abbreviation: "GB", conferenceId: cid, divisionId: did),
              Team(name: "Minnesota Vikings", abbreviation: "MIN", conferenceId: cid, divisionId: did)
            ]
            return teams.map { $0.save(on: c) }
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
    return Division.query(on: connection).filter(\.name == "NFC North")
      .first()
      .flatMap(to: Void.self) { division in
        if let d = division {
          return try d.teams.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}

// A Fluent migration that seeds the Team model with NFC South values
struct SeedNfcSouthTeams : SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "NFC South")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id, let cid = division?.conferenceId {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Atlanta Falcons", abbreviation: "ATL", conferenceId: cid, divisionId: did),
              Team(name: "Carolina Panthers", abbreviation: "CAR", conferenceId: cid, divisionId: did),
              Team(name: "New Orleans Saints", abbreviation: "NO", conferenceId: cid, divisionId: did),
              Team(name: "Tampa Bay Buccaneers", abbreviation: "TB", conferenceId: cid, divisionId: did)
            ]
            return teams.map { $0.save(on: c) }
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
    return Division.query(on: connection).filter(\.name == "NFC South")
      .first()
      .flatMap(to: Void.self) { division in
        if let d = division {
          return try d.teams.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
    }
}

// A Fluent migration that seeds the Team model with NFC East values
struct SeedNfcEastTeams : SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "NFC East")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id, let cid = division?.conferenceId {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Dallas Cowboys", abbreviation: "DAL", conferenceId: cid, divisionId: did),
              Team(name: "New York Giants", abbreviation: "NYG", conferenceId: cid, divisionId: did),
              Team(name: "Philadelphia Eagles", abbreviation: "PHI", conferenceId: cid, divisionId: did),
              Team(name: "Washington Redskins", abbreviation: "WAS", conferenceId: cid, divisionId: did)
            ]
            return teams.map { $0.save(on: c) }
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
    return Division.query(on: connection).filter(\.name == "NFC East")
      .first()
      .flatMap(to: Void.self) { division in
        if let d = division {
          return try d.teams.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}

// A Fluent migration that seeds the Team model with NFC West values
struct SeedNfcWestTeams : SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "NFC West")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id, let cid = division?.conferenceId {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Arizona Cardinals", abbreviation: "ARI", conferenceId: cid, divisionId: did),
              Team(name: "Los Angeles Rams", abbreviation: "LAR", conferenceId: cid, divisionId: did),
              Team(name: "Seattle Seahawks", abbreviation: "SEA", conferenceId: cid, divisionId: did),
              Team(name: "San Francisco 49ers", abbreviation: "SF", conferenceId: cid, divisionId: did)
            ]
            return teams.map { $0.save(on: c) }
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
    return Division.query(on: connection).filter(\.name == "NFC West")
      .first()
      .flatMap(to: Void.self) { division in
        if let d = division {
          return try d.teams.query(on: connection).delete()
        } else {
          return connection.future();
        }
      }
  }
}
