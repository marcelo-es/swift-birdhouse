import Foundation
import Hummingbird

extension RegistryController {

    @Sendable func lookupPackageIdentifiersByURL(
        request: Request,
        context: some RequestContext
    )
        async throws -> EditedResponse<LookupPackageIdentifiersByURL.Response>
    {
        let urlQueryItem = try request.uri.queryParameters.require("url")

        guard let url = URL(string: urlQueryItem) else {
            throw HTTPError(.badRequest)
        }

        guard url.host == "github.com" || url.host == "www.github.com" else {
            throw HTTPError(.notFound)
        }

        guard url.pathComponents.count == 3 else {
            throw HTTPError(.notFound)
        }

        let scope = url.pathComponents[1]
        var name = url.pathComponents[2]
        if name.hasSuffix(".git") {
            name = String(name.dropLast(4))
        }

        let releases = try await repository.list(scope: scope, name: name)

        if releases.isEmpty {
            throw HTTPError(.notFound)
        }

        return EditedResponse(
            headers: [.contentVersion: "1"],
            response: LookupPackageIdentifiersByURL.Response(
                identifiers: ["\(scope).\(name)"]
            )
        )
    }

}

enum LookupPackageIdentifiersByURL {

    struct Response: ResponseEncodable {
        let identifiers: [String]
    }

}
