import Foundation

struct RegistryController<Repository: ReleaseRepository> {

    let baseURL: URL
    let repository: Repository

}
