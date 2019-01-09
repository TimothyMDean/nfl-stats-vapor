import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)

    /// Register the configured SQLite database to the database config.
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig)
    services.register(databasesConfig)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Conference.self, database: .sqlite)
    migrations.add(model: Division.self, database: .sqlite)
    migrations.add(model: Team.self, database: .sqlite)
    migrations.add(model: Season.self, database: .sqlite)
    migrations.add(model: Week.self, database: .sqlite)
    migrations.add(model: Game.self, database: .sqlite)
    migrations.add(migration: SeedConferences.self, database: .sqlite)
    migrations.add(migration: SeedAfcDivisions.self, database: .sqlite)
    migrations.add(migration: SeedNfcDivisions.self, database: .sqlite)
    migrations.add(migration: SeedAfcNorthTeams.self, database: .sqlite)
    migrations.add(migration: SeedAfcSouthTeams.self, database: .sqlite)
    migrations.add(migration: SeedAfcEastTeams.self, database: .sqlite)
    migrations.add(migration: SeedAfcWestTeams.self, database: .sqlite)
    migrations.add(migration: SeedNfcNorthTeams.self, database: .sqlite)
    migrations.add(migration: SeedNfcSouthTeams.self, database: .sqlite)
    migrations.add(migration: SeedNfcEastTeams.self, database: .sqlite)
    migrations.add(migration: SeedNfcWestTeams.self, database: .sqlite)
    services.register(migrations)

}
