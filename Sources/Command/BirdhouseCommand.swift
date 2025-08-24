import ArgumentParser
import Birdhouse
import Logging
import NIOSSL

@main
struct BirdhouseCommand: AsyncParsableCommand {

    @Option(name: .shortAndLong)
    var host: String = "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = 8080

    @OptionGroup(title: "Logging")
    var logging: LoggingOptions

    @Option(name: .customLong("certificate"), help: "PEM file containing certificate chain")
    var certificatePath: String?

    @Option(name: .customLong("private-key"), help: "PEM file containing private key")
    var privateKeyPath: String?

    func validate() throws {
        guard
            (certificatePath == nil && privateKeyPath == nil)
                || (certificatePath != nil && privateKeyPath != nil)
        else {
            throw ValidationError(
                "Both --certificate and --private-key must be provided to enable TLS."
            )
        }
    }

    func run() async throws {
        var logger = Logger(label: "swift-birdhouse")
        logger.logLevel = logging.level

        var tlsConfiguration: TLSConfiguration? = nil
        if let certificatePath, let privateKeyPath {
            let certificate = try NIOSSLCertificate.fromPEMFile(certificatePath)
            let privateKey = try NIOSSLPrivateKey(file: privateKeyPath, format: .pem)
            tlsConfiguration = TLSConfiguration.makeServerConfiguration(
                certificateChain: certificate.map { .certificate($0) },
                privateKey: .privateKey(privateKey)
            )
        }

        let application = try buildApplication(
            host: host,
            port: port,
            tlsConfiguration: tlsConfiguration,
            repository: MemoryReleaseRepository(),
            logger: logger
        )
        try await application.runService()
    }

}

struct LoggingOptions: ParsableArguments {

    @Flag(
        name: [.customShort("v"), .long],
        help: "Increase verbosity to include informational output."
    )
    var verbose: Bool = false

    @Flag(
        name: [.customLong("vv"), .long],
        help: "Increase verbosity to include debug output."
    )
    var veryVerbose: Bool = false

    @Flag(
        name: [.customShort("q"), .long],
        help: "Decrease verbosity to only include error output."
    )
    var quiet: Bool = false

    var level: Logger.Level {
        if veryVerbose {
            .debug
        } else if verbose {
            .info
        } else if quiet {
            .error
        } else {
            .notice
        }
    }

}
