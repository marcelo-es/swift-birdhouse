import Foundation
import Hummingbird
import ZIPFoundation

extension RegistryController {

    @Sendable func fetchManifestForPackageRelease(request: Request, context: some RequestContext)
        async throws -> EditedResponse<String>
    {
        let scope = try context.parameters.require("scope")
        let name = try context.parameters.require("name")
        let version = try context.parameters.require("version")

        let release = try await repository.get(scope: scope, name: name, version: version)

        guard let release else {
            throw HTTPError(.notFound)
        }

        return EditedResponse(
            status: .ok,
            headers: [
                .contentType: "text/x-swift",
                .contentVersion: "1",
            ],
            response: try release.manifest
        )
    }

}

extension Release {

    var manifest: String {
        get throws {
            let archive = try Archive(data: sourceArchive, accessMode: .read)
            guard let manifestEntry = archive.first(where: { $0.path.hasSuffix("/Package.swift") })
            else {
                throw HTTPError(.notFound)
            }

            var manifest: String? = nil
            _ = try archive.extract(manifestEntry) { (data) in
                manifest = String(data: data, encoding: .utf8)
            }

            guard let manifest else {
                throw HTTPError(.notFound)
            }

            return manifest
        }
    }

}
