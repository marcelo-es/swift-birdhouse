@testable import SwiftRegistry
import OpenAPIRuntime
import RegistryAPI
import XCTest

final class RegistryAPI_listPackageReleasesTests: XCTestCase {

    typealias Input = Operations.listPackageReleases.Input
    typealias Output = Operations.listPackageReleases.Output

    var mockRepository: ReleaseMemoryRepository!
    var testSubject: SwiftRegistryAPI<ReleaseMemoryRepository>!

    /// Test a call to the list package releases endpoint.
    ///
    /// The response should be compliant to the specification at 
    /// https://github.com/apple/swift-package-manager/blob/main/Documentation/PackageRegistry/Registry.md#41-list-package-releases 
    ///
    /// ```
    /// HTTP/1.1 200 OK
    /// Content-Type: application/json
    /// Content-Version: 1
    /// Content-Length: 508
    /// Link: <https://github.com/mona/LinkedList>; rel="canonical",
    ///       <ssh://git@github.com:mona/LinkedList.git>; rel="alternate",
    ///       <https://packages.example.com/mona/LinkedList/1.1.1>; rel="latest-version",
    ///       <https://github.com/sponsors/mona>; rel="payment"
    /// 
    /// {
    ///     "releases": {
    ///         "1.1.1": {
    ///             "url": "https://packages.example.com/mona/LinkedList/1.1.1"
    ///         },
    ///         "1.1.0": {
    ///             "url": "https://packages.example.com/mona/LinkedList/1.1.0",
    ///             "problem": {
    ///                 "status": 410,
    ///                 "title": "Gone",
    ///                 "detail": "this release was removed from the registry"
    ///             }
    ///         },
    ///         "1.0.0": {
    ///             "url": "https://packages.example.com/mona/LinkedList/1.0.0"
    ///         }
    ///     }
    /// }
    /// ```
    func testListPackageReleases() async throws {
        mockRepository = ReleaseMemoryRepository(releases: .mock())
        testSubject = .init(repository: ReleaseMemoryRepository())

        let input = Input(
            path: .init(scope: "mona", name: "LinkedList")
        )
        let output = try await testSubject.listPackageReleases(input)

        guard case .ok(let ok) = output else {
            XCTFail("The list package releases call must succeed")
            return
        }

        // Content-Type: application/json
        // TODO

        // Content-Version: 1
        XCTAssertEqual(ok.headers.Content_hyphen_Version, ._1)

        // Content-Length: 508
        XCTAssertEqual(ok.headers.Content_hyphen_Length, 508)

        // Link: <https://github.com/mona/LinkedList>; rel="canonical",
        //       <ssh://git@github.com:mona/LinkedList.git>; rel="alternate",
        //       <https://packages.example.com/mona/LinkedList/1.1.1>; rel="latest-version",
        //       <https://github.com/sponsors/mona>; rel="payment"
        // TODO

        // Body
        guard case .json(let json) = ok.body else {
            XCTFail("The list package releases call must return a JSON.")
            return
        }

        let releases = json.releases.value
        XCTAssertEqual(releases.keys.count, 3)

        //  "1.1.1": {
        //      "url": "https://packages.example.com/mona/LinkedList/1.1.1"
        //  },
        let release_1_1_1 = try XCTUnwrap(releases["1.1.1"] as? OpenAPIObjectContainer)
        XCTAssertEqual(release_1_1_1.value.keys.count, 1)

        let release_1_1_1URL = try XCTUnwrap(release_1_1_1.value["url"] as? String)
        XCTAssertEqual(release_1_1_1URL, "https://packages.example.com/mona/LinkedList/1.1.1")

        // "1.1.0": {
        //     "url": "https://packages.example.com/mona/LinkedList/1.1.0",
        //     "problem": {
        //         "status": 410,
        //         "title": "Gone",
        //         "detail": "this release was removed from the registry"
        //     }
        // },
        let release_1_1_0 = try XCTUnwrap(releases["1.1.0"] as? OpenAPIObjectContainer)
        XCTAssertEqual(release_1_1_0.value.keys.count, 2)

        let release_1_1_0URL = try XCTUnwrap(release_1_1_0.value["url"] as? String)
        XCTAssertEqual(release_1_1_0URL, "https://packages.example.com/mona/LinkedList/1.1.0")
        
        let release_1_1_0Problem = try XCTUnwrap(release_1_1_0.value["problem"] as? OpenAPIObjectContainer)
        XCTAssertEqual(release_1_1_0Problem.value.keys.count, 3)
        
        let release_1_1_0ProblemStatus = try XCTUnwrap(release_1_1_0Problem.value["status"] as? Int)
        XCTAssertEqual(release_1_1_0ProblemStatus, 410)

        let release_1_1_0ProblemTitle = try XCTUnwrap(release_1_1_0Problem.value["title"] as? String)
        XCTAssertEqual(release_1_1_0ProblemTitle, "Gone")

        let release_1_1_0ProblemDetail = try XCTUnwrap(release_1_1_0Problem.value["detail"] as? String)
        XCTAssertEqual(release_1_1_0ProblemDetail, "this release was removed from the registry")

        // "1.0.0": {
        //     "url": "https://packages.example.com/mona/LinkedList/1.0.0"
        // }
        let release_1_0_0 = try XCTUnwrap(releases["1.0.0"] as? OpenAPIObjectContainer)
        XCTAssertEqual(release_1_0_0.value.keys.count, 1)

        let release_1_0_0URL = try XCTUnwrap(release_1_0_0.value["url"] as? String)
        XCTAssertEqual(release_1_0_0URL, "https://packages.example.com/mona/LinkedList/1.0.0")
    }

}
