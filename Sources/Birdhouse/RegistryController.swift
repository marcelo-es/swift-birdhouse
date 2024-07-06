import Foundation
import HTTPTypes
import Hummingbird

struct RegistryController<Repository: ReleaseRepository> {

    let baseURL: URL
    let repository: Repository

    func addRoutes(to group: RouterGroup<some RequestContext>) {
        group.get(":scope/:name", use: listPackageReleases)
        group.get(":scope/:name/:version", use: fetchReleaseMetadata)   
        group.put(":scope/:name/:version", use: publishPackageRelease)   
    }

}

extension HTTPField.Name {

    static let contentVersion = Self("Content-Version")!

}
