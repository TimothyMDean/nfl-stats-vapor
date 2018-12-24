import Vapor

/// Controls basic CRUD operations on `Conference`s.
final class ConferenceController {

    /// Returns a list of all `Conference`s.
    func index(_ req: Request) throws -> Future<[Conference]> {
        return Conference.query(on: req).all()
    }

    /// Saves a decoded `Conference` to the database.
    func create(_ req: Request) throws -> Future<Conference> {
        return try req.content.decode(Conference.self).flatMap { conference in
            return conference.save(on: req)
        }
    }

    /// Deletes a parameterized `Conference`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Conference.self).flatMap { conference in
            return conference.delete(on: req)
        }.transform(to: .ok)
    }
}
