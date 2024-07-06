import Foundation
import Hummingbird

struct RegistryController<Repository: ReleaseRepository> {

    let baseURL: URL
    let repository: Repository

    func addRoutes(to group: RouterGroup<some RequestContext>) {
        group.put(":scope/:name/:version", use: publishPackageRelease)   
    }

}
