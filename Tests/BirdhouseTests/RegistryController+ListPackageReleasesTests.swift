import Foundation
import HTTPTypes
import StructuredFieldValues
import Testing

@testable import Birdhouse

@Suite("List Package Releases")
struct RegistryControllerListPackageReleasesTests {

    let mockReleases: [Release] = Array(Set<Release>.mock())
    let decoder = JSONDecoder()

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

        let problem = try decoder.decode(Problem.self, from: response.body)
        #expect(problem.detail == "Missing Accept header")
    }

    @Test("Unsupported header")
    func unsupportedHeader() async throws {
        let repository = MemoryReleaseRepository(releases: [])
        let application = try buildApplication(repository: repository)

        // WHEN submitting a request without an unsupported Accept header
        let response = try await application.test(.router) { client in
            try await client.executeRequest(
                uri: "https://packages.example.com/anyscope/anypackage",
                method: .get,
                headers: [.accept: "application/json"],
                body: nil
            )
        }

        // THEN server responds with a bad request status
        #expect(response.status == .badRequest)
        #expect(response.headers[.contentVersion] == "1")
        #expect(response.headers[.contentType] == "application/problem+json")

        let problem = try decoder.decode(Problem.self, from: response.body)
        #expect(problem.detail == "Unsupported Accept header")
    }

    @Test("Invalid API version")
    func invalidAPIVersion() async throws {
        let repository = MemoryReleaseRepository(releases: [])
        let application = try buildApplication(repository: repository)

        // WHEN submitting a request without an unsupported Accept header
        let response = try await application.test(.router) { client in
            try await client.executeRequest(
                uri: "https://packages.example.com/anyscope/anypackage",
                method: .get,
                headers: [.accept: "application/vnd.swift.registry.v2+json"],
                body: nil
            )
        }

        // THEN server responds with a bad request status
        #expect(response.status == .badRequest)
        #expect(response.headers[.contentVersion] == "1")
        #expect(response.headers[.contentType] == "application/problem+json")

        let problem = try decoder.decode(Problem.self, from: response.body)
        #expect(problem.detail == "Invalid API version")
    }

    @Test("Unsupported media type")
    func unsupportedMediaType() async throws {
        let repository = MemoryReleaseRepository(releases: [])
        let application = try buildApplication(repository: repository)

        // WHEN submitting a request without an unsupported Accept header
        let response = try await application.test(.router) { client in
            try await client.executeRequest(
                uri: "https://packages.example.com/anyscope/anypackage",
                method: .get,
                headers: [.accept: "application/vnd.swift.registry.v1+excel"],
                body: nil
            )
        }

        // THEN server responds with a bad request status
        #expect(response.status == .unsupportedMediaType)
        #expect(response.headers[.contentVersion] == "1")
        #expect(response.headers[.contentType] == "application/problem+json")

        let problem = try decoder.decode(Problem.self, from: response.body)
        #expect(problem.detail == "Unsupported media type")
    }

    @Test("List releases")
    func listReleases() async throws {
        // GIVEN releases with multiple scopes and names
        let releases: [Release] = [
            .mock(
                id: "022D805C-4726-4F23-9A6B-11BEE3FBBB34",
                scope: "mona",
                name: "LinkedList",
                version: "1.0.0",
            ),
            .mock(
                id: "3D550E25-62AD-4CE1-A2FF-F9B626603FDD",
                scope: "mona",
                name: "LinkedList",
                version: "1.1.0",
            ),
            .mock(
                id: "9B595D15-3E5C-46A8-B770-D8EF9346C132",
                scope: "mona",
                name: "Tree",
                version: "1.1.1",
            ),
            .mock(
                id: "01AB1B56-CF49-4A9E-868A-D7CE40909DAC",
                scope: "lisa",
                name: "BubbleSort",
                version: "2.0.0",
            ),
        ]
        let mockScope = "mona"
        let mockName = "LinkedList"

        // WHEN listing the released packages of the scope `mona` and name `LinkedList`
        let repository = MemoryReleaseRepository(releases: Set(releases))
        let application = try buildApplication(
            host: "packages.example.com",
            port: 80,
            repository: repository
        )

        let response = try await application.test(.router) { client in
            try await client.executeRequest(
                uri: "http://packages.example.com/\(mockScope)/\(mockName)",
                method: .get,
                headers: [.accept: "application/vnd.swift.registry.v1+json"],
                body: nil
            )
        }

        // THEN The headers are as expected
        #expect(response.status == .ok)
        #expect(response.headers[.contentVersion] == "1")
        let contentType = try #require(try ContentType(response.headers[.contentType]))
        #expect(contentType.item == "application/json")

        // AND the body contains the expected releases
        let responseBody = try decoder.decode(
            ListPackageReleases.Response.self,
            from: response.body
        )
        #expect(responseBody.releases.count == 2)

        #expect(
            responseBody.releases["1.0.0"]?.url
                == "http://packages.example.com/\(mockScope)/\(mockName)/1.0.0"
        )
        #expect(
            responseBody.releases["1.1.0"]?.url
                == "http://packages.example.com/\(mockScope)/\(mockName)/1.1.0"
        )
    }

}

struct ContentType: StructuredFieldValue {

    static let structuredFieldType: StructuredFieldType = .item

    let item: String

    init?(_ header: String?) throws {
        guard let header else {
            return nil
        }

        let decoder = StructuredFieldValueDecoder()
        self = try decoder.decode(ContentType.self, from: Array(header.utf8))
    }

}
