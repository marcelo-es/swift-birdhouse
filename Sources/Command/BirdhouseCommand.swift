import ArgumentParser
import Birdhouse

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
