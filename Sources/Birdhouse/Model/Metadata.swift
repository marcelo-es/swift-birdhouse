public struct Metadata: Hashable, Codable, Sendable {

    struct Author: Hashable, Codable {

        struct Organization: Hashable, Codable {
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
