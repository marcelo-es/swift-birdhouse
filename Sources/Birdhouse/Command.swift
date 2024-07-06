import ArgumentParser
import Hummingbird

@main
struct BirdhouseCommand: AsyncParsableCommand, ApplicationArguments {

    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = 8080

    @Flag(name: .shortAndLong)
    var inMemoryTesting: Bool = false

    @Option(name: .customLong("certificate"), help: "PEM file containing certificate chain")
    var certificatePath: String?

    @Option(name: .customLong("private-key"), help: "PEM file containing private key")
    var privateKeyPath: String?

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

    /// Certificate chain file path
    var certificatePath: String? { get }

    /// Private key file path
    var privateKeyPath: String? { get }

}
