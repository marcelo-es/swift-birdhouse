import Foundation
import Hummingbird

extension RegistryController {

    @Sendable func downloadSourceArchive(request: Request, context: some RequestContext) async throws -> EditedResponse<ByteBuffer> {
        let scope = try context.parameters.require("scope")
        let name = try context.parameters.require("name")
        let version = try context.parameters.require("version")

        let release = try await repository.get(scope: scope, name: name, version: version)

        guard let release else {
            throw HTTPError(.notFound)
        }

        let byteBuffer = context.allocator.buffer(data: release.sourceArchive)

        return EditedResponse(
            status: .ok,
            headers: [
                .contentType: "application/zip",
                .contentVersion: "1",
                .contentDisposition: "attachment; filename=\"\(release.sourceArchiveName)\""
            ],
            response: byteBuffer
        )
    }

}

extension Release {

    var sourceArchiveName: String {
        "\(name)-\(version).zip"
    }

}
