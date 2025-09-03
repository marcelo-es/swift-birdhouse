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

        let identifiers = try await repository.identifiers(with: url)

        if identifiers.isEmpty {
            throw HTTPError(.notFound)
        }

        return EditedResponse(
            headers: [.contentVersion: "1"],
            response: LookupPackageIdentifiersByURL.Response(
                identifiers: Array(identifiers)
            )
        )
    }

}

enum LookupPackageIdentifiersByURL {

    struct Response: ResponseEncodable {
        let identifiers: [String]
    }

}
