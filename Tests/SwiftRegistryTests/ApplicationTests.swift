@testable import SwiftRegistry
import Hummingbird
import HummingbirdTesting
import XCTest

final class ApplicationTests: XCTestCase {

    struct TestArguments: ApplicationArguments {
        var hostname: String = "127.0.0.1"
        var port: Int = 8080
        var inMemoryTesting: Bool = true
    }

    var mockScope: String!
    var mockPackageName: String!

    func testApplication() async throws {
        let application = try buildApplication(TestArguments())
        try await application.test(.router) { client in
            try await client.execute(uri: "/", method: .get) { response in
                // XCTAssertEqual(response.status, .ok)
                // XCTAssertEqual(String(buffer: response.body), "Hello")
            }
        }
    }

}
