import RegistryAPI

struct SwiftRegistryAPI<Repository: ReleaseRepository>: APIProtocol {

    let repository: Repository

    package func listPackageReleases(_ input: Operations.listPackageReleases.Input) async throws -> Operations.listPackageReleases.Output {
        .undocumented(statusCode: 501, .notImplemented())
    }

    package func fetchReleaseMetadata(_ input: Operations.fetchReleaseMetadata.Input) async throws -> Operations.fetchReleaseMetadata.Output {
        .undocumented(statusCode: 501, .notImplemented())
    }

    package func publishPackageRelease(_ input: Operations.publishPackageRelease.Input) async throws -> Operations.publishPackageRelease.Output {
        .undocumented(statusCode: 501, .notImplemented())
    }

    package func fetchManifestForPackageRelease(_ input: Operations.fetchManifestForPackageRelease.Input) async throws -> Operations.fetchManifestForPackageRelease.Output {
        .undocumented(statusCode: 501, .notImplemented())
    }

    package func downloadSourceArchive(_ input: Operations.downloadSourceArchive.Input) async throws -> Operations.downloadSourceArchive.Output {
        .undocumented(statusCode: 501, .notImplemented())
    }

    package func lookupPackageIdentifiersByURL(_ input: Operations.lookupPackageIdentifiersByURL.Input) async throws -> Operations.lookupPackageIdentifiersByURL.Output {
        .undocumented(statusCode: 501, .notImplemented())
    }

}
