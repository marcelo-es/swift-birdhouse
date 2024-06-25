import Foundation
import OpenAPIRuntime
import RegistryAPI

struct SwiftRegistryAPI<Repository: ReleaseRepository>: APIProtocol {

    let baseURL: URL
    let repository: Repository

    package func listPackageReleases(_ input: Operations.listPackageReleases.Input) async throws -> Operations.listPackageReleases.Output {
        let scope = input.path.scope
        let name = input.path.name

        let releases = try await repository.list(scope: scope, name: name)

        if releases.isEmpty {
            return .clientError(
                statusCode: 404,
                .init(
                    headers: .init(Content_hyphen_Version: ._1),
                    body: .application_problem_plus_json(
                        .init(
                            _type: "",
                            title: "",
                            status: 404,
                            instance: "",
                            detail: ""
                        )
                    )
                )
            )
        }

        var releasesObject = [String: (any Sendable)]()
        for release in releases {
            var releaseObject = [String: (any Sendable)]()
            releaseObject["url"] = "\(baseURL.absoluteString)/\(release.scope)/\(release.name)/\(release.version)"

            releasesObject[release.version] = releaseObject
        }

        let outputObject = try OpenAPIObjectContainer(unvalidatedValue: releasesObject)

        return .ok(
            .init(
                headers: .init(Content_hyphen_Version: ._1),
                body: .json(
                    .init(releases: outputObject)
                )
            )
        )

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
