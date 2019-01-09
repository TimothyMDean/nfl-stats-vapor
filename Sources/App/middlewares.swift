import Vapor

// Adds middlewares to the Vapor middleware configuration
public func middlewares(config: inout MiddlewareConfig) throws {
  config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
}
