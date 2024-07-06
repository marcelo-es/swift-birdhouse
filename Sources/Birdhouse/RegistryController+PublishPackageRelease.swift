import Foundation
import Hummingbird
import HTTPTypes
import MultipartKit

extension RegistryController {

    @Sendable func publishPackageRelease(request: Request, context: some RequestContext) async throws -> Response? {
        let scope = try context.parameters.require("scope")
        let name = try context.parameters.require("scope")
        let version = try context.parameters.require("version")

        let decodedRequest = try await FormDataDecoder().decode(
            PublishPackageRelease.Request.self,
            from: request,
            context: context
        )

        _ = try await repository.create(
            scope: scope,
            name: name,
            version: version,
            sourceArchive: decodedRequest.sourceArchive
        )

        return Response(
            status: .created,
            headers: [.contentVersion: "1"]
        )
    }

}

enum PublishPackageRelease {

    struct Request: Decodable {

        enum CodingKeys: String, CodingKey {
            case sourceArchive = "source-archive"
            case sourceArchiveSignature = "source-archive-signature"
            case metadata = "metadata"
            case metadataSignature = "metadata-signature"
        }

        let sourceArchive: Data
        let sourceArchiveSignature: Data?
        let metadata: Data?
        let metadataSignature: Data?

    }

}

extension FormDataDecoder {

    /// Decode from a Hummingbird request.
    public func decode<T: Decodable>(_ type: T.Type, from request: Request, context: some RequestContext) async throws -> T {
        guard let contentType = request.headers[.contentType],
              let mediaType = MediaType(from: contentType),
              let parameter = mediaType.parameter,
              parameter.name == "boundary"
        else {
            throw HTTPError(.unsupportedMediaType)
        }

        let buffer = try await request.body.collect(upTo: 10_000_000)
        return try self.decode(T.self, from: buffer, boundary: parameter.value)
    }

}

extension HTTPField.Name {

    static let contentVersion = Self("Content-Version")!

}
