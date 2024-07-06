import Foundation
import Hummingbird

extension RegistryController {

    @Sendable func listPackageReleases(request: Request, context: some RequestContext) async throws -> EditedResponse<ListPackageReleases.Response> {
        let scope = try context.parameters.require("scope")
        let name = try context.parameters.require("name")

        let releases = try await repository.list(scope: scope, name: name)

        if releases.isEmpty {
            throw HTTPError(.notFound)
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

    struct Response: ResponseEncodable {

        struct Release: Encodable {
            let url: String?
        }

        let releases: [String: Release]

    }

}

extension ListPackageReleases.Response {

    init(from releases: [Birdhouse.Release], baseURL: URL) {
        self.releases = Dictionary(uniqueKeysWithValues: releases.map { release in
            let url = "\(baseURL)/\(release.scope)/\(release.name)/\(release.version)"
            return (release.version, Release(url: url))
        })
    }

}
