@testable import Birdhouse

extension Metadata {

    static func mock(
        author: Author = .mock(),
        description: String? = "A linked list implementation in Swift.",
        licenseURL: String? = "https://opensource.org/licenses/MIT",
        originalPublicationTime: String? = "2023-10-01T12:00:00Z",
        readmeURL: String? = "https://example.com/LinkedList/README.md",
        repositoryURLs: [String]? = [
            "https://acme.repo/mona/lisa"
        ]
    ) -> Self {
        Metadata(
            author: author,
            description: description,
            licenseURL: licenseURL,
            originalPublicationTime: originalPublicationTime,
            readmeURL: readmeURL,
            repositoryURLs: repositoryURLs
        )
    }

}

extension Metadata.Author {

    static func mock(
        name: String = "Mona Lisa",
        email: String? = "mona@lisa.me",
        description: String? = "I love data structures.",
        organization: Organization? = .mock(),
        url: String? = "https://mona.lisa"
    ) -> Self {
        Metadata.Author(
            name: name,
            email: email,
            description: description,
            organization: organization,
            url: url
        )
    }

}

extension Metadata.Author.Organization {

    static func mock(
        name: String = "ACME Inc.",
        email: String? = "acme@acme.example",
        description: String? = "We build everything.",
        url: String? = "https://acme.example"
    ) -> Self {
        Metadata.Author.Organization(
            name: name,
            email: email,
            description: description,
            url: url
        )
    }

}
