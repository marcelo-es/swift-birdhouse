import Foundation
import Hummingbird

extension RegistryController {

    @Sendable func listPackageReleases(
        request: Request,
        context: some RequestContext
    ) async throws -> EditedResponse<ListPackageReleases.Response> {
        let scope = try context.parameters.require("scope")
        let name = try context.parameters.require("name")

        try assertAccept(headers: request.headers, mediaType: .json)

        let releases = try await repository.list(scope: scope, name: name)

        if releases.isEmpty {
            throw Problem(status: .notFound, detail: "Releases not found")
        }

        let response = ListPackageReleases.Response(from: releases, baseURL: baseURL)
        let editedResponse = EditedResponse(
            headers: [.contentVersion: "1"],
            response: response
        )

        return editedResponse
    }

}

enum ListPackageReleases {

    struct Response: ResponseCodable {

        struct Release: Codable {
            let url: String?
        }

        let releases: [String: Release]

    }

}

private typealias ModelRelease = Release

extension ListPackageReleases.Response {

    fileprivate init(from releases: [ModelRelease], baseURL: URL) {
        self.releases = Dictionary(
            uniqueKeysWithValues: releases.map { release in
                let url = "\(baseURL)/\(release.scope)/\(release.name)/\(release.version)"
                return (release.version, Release(url: url))
            }
        )
    }

}
