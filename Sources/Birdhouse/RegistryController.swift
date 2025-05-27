import Foundation
import HTTPTypes
import Hummingbird

struct RegistryController<Repository: ReleaseRepository> {

    let baseURL: URL
    let repository: Repository

    func addRoutes(to router: Router<some RequestContext>) {
        router.get("{scope}/{name}", use: listPackageReleases)
        router.get("{scope}/{name}/{version}", use: fetchReleaseMetadata)
        router.get("{scope}/{name}/{version}/Package.swift", use: fetchManifestForPackageRelease)
        router.get("{scope}/{name}/{version}.zip", use: downloadSourceArchive)
        router.get("identifiers", use: lookupPackageIdentifiersByURL)
        router.put("{scope}/{name}/{version}", use: publishPackageRelease)
    }

}

extension HTTPField.Name {

    static let contentVersion = Self("Content-Version")!

}
