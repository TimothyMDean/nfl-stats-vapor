import Vapor
import FluentSQLite

// Adds middlewares to the Vapor migration configuration
public func migrate(config: inout MigrationConfig) throws {
  config.add(model: Conference.self, database: .sqlite)
  config.add(model: Division.self, database: .sqlite)
  config.add(model: Team.self, database: .sqlite)
  config.add(model: Season.self, database: .sqlite)
  config.add(model: Week.self, database: .sqlite)
  config.add(model: Game.self, database: .sqlite)
  config.add(migration: SeedConferences.self, database: .sqlite)
  config.add(migration: SeedAfcDivisions.self, database: .sqlite)
  config.add(migration: SeedNfcDivisions.self, database: .sqlite)
  config.add(migration: SeedAfcNorthTeams.self, database: .sqlite)
  config.add(migration: SeedAfcSouthTeams.self, database: .sqlite)
  config.add(migration: SeedAfcEastTeams.self, database: .sqlite)
  config.add(migration: SeedAfcWestTeams.self, database: .sqlite)
  config.add(migration: SeedNfcNorthTeams.self, database: .sqlite)
  config.add(migration: SeedNfcSouthTeams.self, database: .sqlite)
  config.add(migration: SeedNfcEastTeams.self, database: .sqlite)
  config.add(migration: SeedNfcWestTeams.self, database: .sqlite)
}
