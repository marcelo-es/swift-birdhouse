import Foundation

/// Implementation of `ReleaseRepository` that stores releases in memory.
actor MemoryReleaseRepository: ReleaseRepository {

    var releases: Set<Release>

    init(releases: Set<Release> = []) {
        self.releases = releases
    }

    func create(scope: String, name: String, version: String, sourceArchive: Data) throws -> Release {
        let release = Release(
            id: UUID(),
            scope: scope,
            name: name,
            version: version,
            problem: nil,
            sourceArchive: sourceArchive
        )
        releases.insert(release)
        return release
    }

    func list(scope: String, name: String) async throws -> [Release] {
        releases.filter { $0.scope == scope && $0.name == name }
    }

}
