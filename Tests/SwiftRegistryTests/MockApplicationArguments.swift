@testable import SwiftRegistry

struct MockApplicationArguments: ApplicationArguments {
    let hostname: String = "127.0.0.1"
    let port: Int = 8080
    let inMemoryTesting: Bool = true
}
