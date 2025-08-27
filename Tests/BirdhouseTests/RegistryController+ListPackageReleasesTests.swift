import Foundation
import HTTPTypes
import NIOCore
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

        let problem = try Problem(buffer: response.body)
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

        let problem = try Problem(buffer: response.body)
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

        let problem = try Problem(buffer: response.body)
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

        let problem = try Problem(buffer: response.body)
        #expect(problem.detail == "Unsupported media type")
    }

    @Test("List package releases")
    func testList() async throws {
        let releases = Set<Release>.mock()
        let release = releases.first!

        let repository = MemoryReleaseRepository(releases: releases)
        let application = try buildApplication(repository: repository)

        let response = try await application.test(.router) { client in
            try await client.executeRequest(
                uri: "https://packages.example.com/\(release.scope)/\(release.name)",
                method: .get,
                headers: [.accept: "application/vnd.swift.registry.v1+json"],
                body: nil
            )
        }

        #expect(response.status == .ok)
    }

}

extension Problem {

    init(buffer: ByteBuffer) throws {
        let jsonBody = Data(buffer: buffer)
        let codable = try JSONDecoder().decode(Problem.CodableFormat.self, from: jsonBody)

        self.init(
            type: codable.type,
            title: codable.title,
            status: HTTPResponse.Status(integerLiteral: codable.status),
            detail: codable.detail,
            instance: codable.instance,
        )
    }

}
