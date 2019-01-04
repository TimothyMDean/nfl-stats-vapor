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
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Conference.self, database: .sqlite)
    migrations.add(model: Division.self, database: .sqlite)
    migrations.add(model: Team.self, database: .sqlite)
    migrations.add(model: Season.self, database: .sqlite)
    migrations.add(model: Week.self, database: .sqlite)
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
