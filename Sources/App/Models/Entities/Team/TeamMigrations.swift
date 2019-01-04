import FluentSQLite
import Vapor

// A Fluent migration that seeds the Team model with AFC North values
struct SeedAfcNorthTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "AFC North")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Baltimore Ravens", abbreviation: "BAL", divisionId: did),
              Team(name: "Cincinnati Bengals", abbreviation: "CIN", divisionId: did),
              Team(name: "Cleveland Browns", abbreviation: "CLE", divisionId: did),
              Team(name: "Pittsburgh Steelers", abbreviation: "PIT", divisionId: did)
            ]
            return teams.map { team in
              team.save(on: c)
            }.flatten(on: c).transform(to: Void())
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
struct SeedAfcSouthTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "AFC South")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Houston Texans", abbreviation: "HOU", divisionId: did),
              Team(name: "Indianapolis Colts", abbreviation: "IND", divisionId: did),
              Team(name: "Jacksonville Jaguars", abbreviation: "JAX", divisionId: did),
              Team(name: "Tennessee Titans", abbreviation: "TEN", divisionId: did)
            ]
            return teams.map { team in
              team.save(on: c)
            }.flatten(on: c).transform(to: Void())
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
struct SeedAfcEastTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "AFC East")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Buffalo Bills", abbreviation: "BUF", divisionId: did),
              Team(name: "Miami Dolphins", abbreviation: "MIA", divisionId: did),
              Team(name: "New England Patriots", abbreviation: "NE", divisionId: did),
              Team(name: "New York Jets", abbreviation: "NYJ", divisionId: did)
            ]
            return teams.map { team in
              team.save(on: c)
            }.flatten(on: c).transform(to: Void())
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
struct SeedAfcWestTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "AFC West")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Denver Broncos", abbreviation: "DEN", divisionId: did),
              Team(name: "Kansas City Chiefs", abbreviation: "KC", divisionId: did),
              Team(name: "Los Angeles Chargers", abbreviation: "LAC", divisionId: did),
              Team(name: "Oakland Raiders", abbreviation: "OAK", divisionId: did)
            ]
            return teams.map { team in
              team.save(on: c)
            }.flatten(on: c).transform(to: Void())
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
struct SeedNfcNorthTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "NFC North")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Chicago Bears", abbreviation: "CHI", divisionId: did),
              Team(name: "Detroit Lions", abbreviation: "DET", divisionId: did),
              Team(name: "Green Bay Packers", abbreviation: "GB", divisionId: did),
              Team(name: "Minnesota Vikings", abbreviation: "MIN", divisionId: did)
            ]
            return teams.map { team in
              team.save(on: c)
            }.flatten(on: c).transform(to: Void())
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
struct SeedNfcSouthTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "NFC South")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Atlanta Falcons", abbreviation: "ATL", divisionId: did),
              Team(name: "Carolina Panthers", abbreviation: "CAR", divisionId: did),
              Team(name: "New Orleans Saints", abbreviation: "NO", divisionId: did),
              Team(name: "Tampa Bay Buccaneers", abbreviation: "TB", divisionId: did)
            ]
            return teams.map { team in
              team.save(on: c)
            }.flatten(on: c).transform(to: Void())
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
struct SeedNfcEastTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "NFC East")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Dallas Cowboys", abbreviation: "DAL", divisionId: did),
              Team(name: "New York Giants", abbreviation: "NYG", divisionId: did),
              Team(name: "Philadelphia Eagles", abbreviation: "PHI", divisionId: did),
              Team(name: "Washington Redskins", abbreviation: "WAS", divisionId: did)
            ]
            return teams.map { team in
              team.save(on: c)
            }.flatten(on: c).transform(to: Void())
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
struct SeedNfcWestTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    return Division.query(on: connection).filter(\.name == "NFC West")
      .first()
      .flatMap(to: Void.self) { division in
        if let did = division?.id {
          return connection.transaction(on: .sqlite) { c in
            let teams = [
              Team(name: "Arizona Cardinals", abbreviation: "ARI", divisionId: did),
              Team(name: "Los Angeles Rams", abbreviation: "LAR", divisionId: did),
              Team(name: "Seattle Seahawks", abbreviation: "SEA", divisionId: did),
              Team(name: "San Francisco 49ers", abbreviation: "SF", divisionId: did)
            ]
            return teams.map { team in
              team.save(on: c)
            }.flatten(on: c).transform(to: Void())
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
