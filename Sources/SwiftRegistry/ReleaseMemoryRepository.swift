import Foundation

/// Implementation of `ReleaseRepository` that stores releases in memory.
actor ReleaseMemoryRepository: ReleaseRepository {

    var releases: [UUID: Release] = [:]

    func create(scope: String, name: String, version: String) throws -> Release {
        let id = UUID()
        let release = Release(
            id: id,
            scope: scope,
            name: name,
            version: version
        )
        releases[id] = release
        return release
    }

    func list(scope: String, name: String) async throws -> [Release] {
        releases.values.filter { $0.scope == scope && $0.name == name }
    }

}
