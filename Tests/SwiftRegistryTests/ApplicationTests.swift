@testable import Birdhouse
import Hummingbird
import HummingbirdTesting
import Testing

@Test("Router Configuration",
      .disabled("Disabled until the router is configured"))
func application() async throws {
    let application = try buildApplication(MockApplicationArguments())
    try await application.test(.router) { client in
        try await client.execute(uri: "/", method: .get) { response in
            #expect(response.status == .ok)
            #expect(String(buffer: response.body) == "Hello")
        }
    }
}
