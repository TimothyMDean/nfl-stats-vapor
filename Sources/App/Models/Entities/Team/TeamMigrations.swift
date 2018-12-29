import FluentSQLite
import Vapor

// A Fluent migration that seeds the Team model with AFC North values
struct SeedAfcNorthTeams: SQLiteMigration {

  // Performs the preparation of the migration
  static func prepare(on connection: SQLiteConnection) -> Future<Void> {

    return connection.transaction(on: .sqlite) { _ in
      return Division.query(on: connection).filter(\.name == "AFC North")
        .first()
        .flatMap(to: Void.self) { division in
          if let did = division?.id {
            return Team(name: "Baltimore Ravens", abbreviation: "BAL", divisionId: did).save(on: connection).flatMap { _ in
              return Team(name: "Cincinnati Bengals", abbreviation: "CIN", divisionId: did).save(on: connection).flatMap { _ in
                return Team(name: "Cleveland Browns", abbreviation: "CLE", divisionId: did).save(on: connection).flatMap { _ in
                  return Team(name: "Pittsburgh Steelers", abbreviation: "PIT", divisionId: did).save(on: connection)
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

    return connection.transaction(on: .sqlite) { _ in
      return Division.query(on: connection).filter(\.name == "AFC South")
        .first()
        .flatMap(to: Void.self) { division in
          if let did = division?.id {
            return Team(name: "Houston Texans", abbreviation: "HOU", divisionId: did).save(on: connection).flatMap { _ in
              return Team(name: "Indianapolis Colts", abbreviation: "IND", divisionId: did).save(on: connection).flatMap { _ in
                return Team(name: "Jacksonville Jaguars", abbreviation: "JAX", divisionId: did).save(on: connection).flatMap { _ in
                  return Team(name: "Tennessee Titans", abbreviation: "TEN", divisionId: did).save(on: connection)
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

    return connection.transaction(on: .sqlite) { _ in
      return Division.query(on: connection).filter(\.name == "AFC East")
        .first()
        .flatMap(to: Void.self) { division in
          if let did = division?.id {
            return Team(name: "Buffalo Bills", abbreviation: "BUF", divisionId: did).save(on: connection).flatMap { _ in
              return Team(name: "Miami Dolphins", abbreviation: "MIA", divisionId: did).save(on: connection).flatMap { _ in
                return Team(name: "New England Patriots", abbreviation: "NE", divisionId: did).save(on: connection).flatMap { _ in
                  return Team(name: "New York Jets", abbreviation: "NYJ", divisionId: did).save(on: connection)
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

    return connection.transaction(on: .sqlite) { _ in
      return Division.query(on: connection).filter(\.name == "AFC West")
        .first()
        .flatMap(to: Void.self) { division in
          if let did = division?.id {
            return Team(name: "Denver Broncos", abbreviation: "DEN", divisionId: did).save(on: connection).flatMap { _ in
              return Team(name: "Kansas City Chiefs", abbreviation: "KC", divisionId: did).save(on: connection).flatMap { _ in
                return Team(name: "Los Angeles Chargers", abbreviation: "LAC", divisionId: did).save(on: connection).flatMap { _ in
                  return Team(name: "Oakland Raiders", abbreviation: "OAK", divisionId: did).save(on: connection)
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

    return connection.transaction(on: .sqlite) { _ in
      return Division.query(on: connection).filter(\.name == "NFC North")
        .first()
        .flatMap(to: Void.self) { division in
          if let did = division?.id {
            return Team(name: "Chicago Bears", abbreviation: "CHI", divisionId: did).save(on: connection).flatMap { _ in
              return Team(name: "Detroit Lions", abbreviation: "DET", divisionId: did).save(on: connection).flatMap { _ in
                return Team(name: "Green Bay Packers", abbreviation: "GB", divisionId: did).save(on: connection).flatMap { _ in
                  return Team(name: "Minnesota Vikings", abbreviation: "MIN", divisionId: did).save(on: connection)
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

    return connection.transaction(on: .sqlite) { _ in
      return Division.query(on: connection).filter(\.name == "NFC South")
        .first()
        .flatMap(to: Void.self) { division in
          if let did = division?.id {
            return Team(name: "Atlanta Falcons", abbreviation: "ATL", divisionId: did).save(on: connection).flatMap { _ in
              return Team(name: "Carolina Panthers", abbreviation: "CAR", divisionId: did).save(on: connection).flatMap { _ in
                return Team(name: "New Orleans Saints", abbreviation: "NO", divisionId: did).save(on: connection).flatMap { _ in
                  return Team(name: "Tampa Bay Buccaneers", abbreviation: "TB", divisionId: did).save(on: connection)
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

    return connection.transaction(on: .sqlite) { _ in
      return Division.query(on: connection).filter(\.name == "NFC East")
        .first()
        .flatMap(to: Void.self) { division in
          if let did = division?.id {
            return Team(name: "Dallas Cowboys", abbreviation: "DAL", divisionId: did).save(on: connection).flatMap { _ in
              return Team(name: "New York Giants", abbreviation: "NYG", divisionId: did).save(on: connection).flatMap { _ in
                return Team(name: "Philadelphia Eagles", abbreviation: "PHI", divisionId: did).save(on: connection).flatMap { _ in
                  return Team(name: "Washington Redskins", abbreviation: "WAS", divisionId: did).save(on: connection)
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

    return connection.transaction(on: .sqlite) { _ in
      return Division.query(on: connection).filter(\.name == "NFC West")
        .first()
        .flatMap(to: Void.self) { division in
          if let did = division?.id {
            return Team(name: "Arizona Cardinals", abbreviation: "ARI", divisionId: did).save(on: connection).flatMap { _ in
              return Team(name: "Los Angeles Rams", abbreviation: "LAR", divisionId: did).save(on: connection).flatMap { _ in
                return Team(name: "Seattle Seahawks", abbreviation: "SEA", divisionId: did).save(on: connection).flatMap { _ in
                  return Team(name: "San Francisco 49ers", abbreviation: "SF", divisionId: did).save(on: connection)
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
