import Foundation

/// Implementation of `ReleaseRepository` that stores releases in memory.
public actor MemoryReleaseRepository: ReleaseRepository {

    var releases: Set<Release>

    public init(releases: Set<Release> = []) {
        self.releases = releases
    }

    public func create(
        scope: String,
        name: String,
        version: String,
        sourceArchive: Data,
        metadata: Metadata?
    ) throws -> Release {
        let release = Release(
            id: UUID(),
            scope: scope,
            name: name,
            version: version,
            sourceArchive: sourceArchive,
            publishedAt: Date(),
            metadata: metadata
        )
        releases.insert(release)
        return release
    }

    public func get(scope: String, name: String, version: String) async throws -> Release? {
        releases.first { $0.scope == scope && $0.name == name && $0.version == version }
    }

    public func list(scope: String, name: String) async throws -> [Release] {
        releases.filter { $0.scope == scope && $0.name == name }
    }

    // TODO: Test
    public func identifiers(with url: URL) async throws -> Set<String> {
        let identifiers = releases.filter {
            $0.metadata?.repositoryURLs?.contains { $0 == url.absoluteString } == true
        }
        .map { "\($0.scope).\($0.name)" }
        return Set(identifiers)
    }

}
