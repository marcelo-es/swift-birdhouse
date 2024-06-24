@testable import SwiftRegistry
import Hummingbird
import HummingbirdTesting
import Testing

@Test("Router Configuration",
      .disabled("Disabled until the router is configured"))
func application() async throws {
    let application = try buildApplication(MockArguments())
    try await application.test(.router) { client in
        try await client.execute(uri: "/", method: .get) { response in
            #expect(response.status == .ok)
            #expect(String(buffer: response.body) == "Hello")
        }
    }
}

struct MockArguments: ApplicationArguments {
    let hostname: String = "127.0.0.1"
    let port: Int = 8080
    let inMemoryTesting: Bool = true
}
