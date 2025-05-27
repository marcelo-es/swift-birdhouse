import Foundation
import Hummingbird
import Zip

extension RegistryController {

    @Sendable func fetchManifestForPackageRelease(
        request: Request, context: some RequestContext
    )
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
            let fileManager = FileManager.default

            // TODO: Move into repository

            // Save archive locally and unzip it
            let zipFile = fileManager.temporaryDirectory.appending(path: "\(UUID().uuidString).zip")
            try sourceArchive.write(to: zipFile)
            let unzippedDirectory = try Zip.quickUnzipFile(zipFile)

            guard let manifest = try findManifest(at: unzippedDirectory) else {
                throw HTTPError(.notFound)
            }

            return manifest
        }
    }

    /// Check the directory and the immediate subdirectories for Package.swift.
    func findManifest(at directory: URL) throws -> String? {
        let fileManager = FileManager.default

        if let manifest = manifest(at: directory) {
            return manifest
        }

        let subdirectories = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        for subdirectory in subdirectories {
            if let manifest = manifest(at: subdirectory) {
                return manifest
            }
        }

        return nil
    }

    func manifest(at directory: URL) -> String? {
        let fileManager = FileManager.default
        let file = directory.appending(path: "Package.swift", directoryHint: .notDirectory)

        guard let fileData = fileManager.contents(atPath: file.path()) else {
            return nil
        }

        return String(data: fileData, encoding: .utf8)
    }

}
