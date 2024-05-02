import ArgumentParser
import Hummingbird

@main
struct SwiftRegistryCommand: AsyncParsableCommand {

    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = 8080

    func run() async throws {
        let application = buildApplication(
            configuration: .init(
                address: .hostname(self.hostname, port: self.port),
                serverName: "Hummingbird"
            )
        )
        try await application.runService()
    }

}
