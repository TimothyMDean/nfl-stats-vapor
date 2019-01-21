import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    /// Register providers first
    try services.register(FluentSQLiteProvider())

    services.register(SQLiteConferenceRepository.self)
    services.register(SQLiteDivisionRepository.self)
    services.register(SQLiteTeamRepository.self)

    /// Register routes to the router
    services.register(Router.self) { container -> EngineRouter in
      let router = EngineRouter.default()
      try routes(router, container)
      return router
    }

    /// Register middleware
    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)

    /// Register the database
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig)
    services.register(databasesConfig)

    /// Configure migrations
    var migrationConfig = MigrationConfig()
    try migrate(config: &migrationConfig)
    services.register(migrationConfig)
}
