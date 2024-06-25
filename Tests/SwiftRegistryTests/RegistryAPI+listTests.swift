import Foundation
import OpenAPIRuntime
import RegistryAPI
import Testing

@testable import SwiftRegistry

@Test func listPackages() async throws {
    let mockBaseURL = URL(string: "https://packages.example.com")!
    let mockRepository = ReleaseMemoryRepository(releases: .mock())
    let testSubject = SwiftRegistryAPI(baseURL: mockBaseURL, repository: mockRepository)

    let input = Operations.listPackageReleases.Input(
        path: .init(scope: "mona", name: "LinkedList")
    )
    let output = try await testSubject.listPackageReleases(input)

    let okOutput = try #require(try output.ok)

    // Content-Type: application/json
    // TODO

    // Content-Version: 1
    #expect(okOutput.headers.Content_hyphen_Version == ._1)

    // Content-Length: 508
    // TODO: Implement content length
    // #expect(okOutput.headers.Content_hyphen_Length == 508)

    // Link: <https://github.com/mona/LinkedList>; rel="canonical",
    //       <ssh://git@github.com:mona/LinkedList.git>; rel="alternate",
    //       <https://packages.example.com/mona/LinkedList/1.1.1>; rel="latest-version",
    //       <https://github.com/sponsors/mona>; rel="payment"
    // TODO

    // Body
    let jsonBody = try #require(try okOutput.body.json)

    let releases = jsonBody.releases.value
    #expect(releases.keys.count == 3)

    //  "1.1.1": {
    //      "url": "https://packages.example.com/mona/LinkedList/1.1.1"
    //  },
    let release_1_1_1 = try #require(releases["1.1.1"] as? [String: Any])
    #expect(release_1_1_1.keys.count == 1)

    let release_1_1_1URL = try #require(release_1_1_1["url"] as? String)
    #expect(release_1_1_1URL == "https://packages.example.com/mona/LinkedList/1.1.1")

    // "1.1.0": {
    //     "url": "https://packages.example.com/mona/LinkedList/1.1.0",
    //     "problem": {
    //         "status": 410,
    //         "title": "Gone",
    //         "detail": "this release was removed from the registry"
    //     }
    // },
    let release_1_1_0 = try #require(releases["1.1.0"] as? [String: Any])
    #expect(release_1_1_0.keys.count == 2)

    let release_1_1_0URL = try #require(release_1_1_0["url"] as? String)
    #expect(release_1_1_0URL == "https://packages.example.com/mona/LinkedList/1.1.0")

    let release_1_1_0Problem = try #require(release_1_1_0["problem"] as? [String: Any])
    #expect(release_1_1_0Problem.keys.count == 3)

    let release_1_1_0ProblemStatus = try #require(release_1_1_0Problem["status"] as? Int)
    #expect(release_1_1_0ProblemStatus == 410)

    let release_1_1_0ProblemTitle = try #require(release_1_1_0Problem["title"] as? String)
    #expect(release_1_1_0ProblemTitle == "Gone")

    let release_1_1_0ProblemDetail = try #require(release_1_1_0Problem["detail"] as? String)
    #expect(release_1_1_0ProblemDetail == "this release was removed from the registry")

    // "1.0.0": {
    //     "url": "https://packages.example.com/mona/LinkedList/1.0.0"
    // }
    let release_1_0_0 = try #require(releases["1.0.0"] as? [String: Any])
    #expect(release_1_0_0.keys.count == 1)

    let release_1_0_0URL = try #require(release_1_0_0["url"] as? String)
    #expect(release_1_0_0URL == "https://packages.example.com/mona/LinkedList/1.0.0")
}
