import CryptoKit
import Foundation
import Hummingbird

extension RegistryController {

    @Sendable func fetchReleaseMetadata(request: Request, context: some RequestContext) async throws -> EditedResponse<FetchReleaseMetadata.Response> {
        let scope = try context.parameters.require("scope")
        let name = try context.parameters.require("name")
        let version = try context.parameters.require("version")

        let release = try await repository.get(scope: scope, name: name, version: version)

        guard let release else {
            throw HTTPError(.notFound)
        }

        return EditedResponse(
            headers: [.contentVersion: "1"],
            response: FetchReleaseMetadata.Response(from: release)
        )
    }

}

enum FetchReleaseMetadata {

    struct Response: ResponseEncodable {

        struct Resource: Encodable {
            struct Signing: Encodable {
                let signatureBase64Encoded: String
                let signatureFormat: String
            }

            let name: String
            let type: String
            let checksum: String
            let signing: Signing?
        }

        struct Metadata: Encodable {
            struct Author: Encodable {
                struct Organization: Encodable {
                    let name: String
                    let email: String?
                    let description: String?
                    let url: String?
                }

                let name: String
                let email: String?
                let description: String?
                let organization: Organization?
                let url: String?
            }
        
            let author: Author
            let description: String?
            let licenseURL: String?
            let originalPublicationTime: String?
            let readmeURL: String?
            let repositoryURLs: [String]?
        }

        let id: String
        let version: String
        let resources: [Resource]
        let metadata: Metadata?
        let publishedAt: String

    }

}

extension FetchReleaseMetadata.Response {

    init(from release: Birdhouse.Release) {
        self.init(
            id: "\(release.scope).\(release.name)",
            version: release.version,
            resources: [
                Resource(
                    name: "source-archive",
                    type: "application/zip",
                    checksum: release.sourceArchive.sha256,
                    signing: nil
                )
            ],
            metadata: nil,
            publishedAt: release.publishedAt.iso8601
        )
    }

}

extension Data {

    var sha256: String {
        SHA256.hash(data: self).compactMap { String(format: "%02x", $0) }.joined()
    }

}

extension Date {
    
    var iso8601: String {
        ISO8601DateFormatter().string(from: self)
    }

}
