import Foundation
import Testing

@testable import Birdhouse

@Suite("List Package Releases")
struct RegistryControllerListPackageReleasesTests {

    let mockReleases: [Release] = Array(Set<Release>.mock())

    @Test("Missing header")
    func missingHeader() async throws {
        let repository = MemoryReleaseRepository(releases: [])
        let application = try buildApplication(repository: repository)

        // WHEN submitting a request without an Accept header
        let response = try await application.test(.router) { client in
            try await client.executeRequest(
                uri: "https://packages.example.com/anyscope/anypackage",
                method: .get,
                headers: [:],
                body: nil
            )
        }

        // THEN server responds with a bad request status
        #expect(response.status == .badRequest)
        #expect(response.headers[.contentVersion] == "1")
        #expect(response.headers[.contentType] == "application/problem+json")

        let jsonBody = Data(buffer: response.body)
        let problem = try JSONDecoder().decode(Problem.CodableFormat.self, from: jsonBody)
        #expect(problem.detail == "missing Accept header")
    }

}
