import ArgumentParser
import Hummingbird

@main
struct SwiftRegistryCommand: AsyncParsableCommand, ApplicationArguments {

    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = 8080

    @Flag(name: .shortAndLong)
    var inMemoryTesting: Bool = false

    func run() async throws {
        let application = try buildApplication(self)
        try await application.runService()
    }

}

protocol ApplicationArguments {

    /// Hostname to bind to
    var hostname: String { get }

    /// Port to bind to
    var port: Int { get }

    /// Use in-memory testing
    var inMemoryTesting: Bool { get }

}
