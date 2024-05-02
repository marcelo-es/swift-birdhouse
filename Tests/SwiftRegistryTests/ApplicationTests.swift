@testable import SwiftRegistry
import Hummingbird
import HummingbirdTesting
import XCTest

final class ApplicationTests: XCTestCase {

    func testApplication() async throws {
        let application = buildApplication(configuration: .init())
        try await application.test(.router) { client in
            try await client.execute(uri: "/", method: .get) { response in
                XCTAssertEqual(response.status, .ok)
                XCTAssertEqual(String(buffer: response.body), "Hello")
            }
        }
    }

}
