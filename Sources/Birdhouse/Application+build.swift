import Foundation
import Hummingbird
import HummingbirdCore
import HummingbirdTLS
import Logging
import NIOSSL

func buildApplication(_ arguments: ApplicationArguments) throws -> some ApplicationProtocol {
    var logger = Logger(label: "swift-birdhouse")
    logger.logLevel = .debug

    let router = Router()

    router.middlewares.add(LogRequestsMiddleware(.info))

    let repository = MemoryReleaseRepository()
    let registryController = RegistryController(
        baseURL: try arguments.baseURL,
        repository: repository
    )
    registryController.addRoutes(to: router.group())
    
    let server: HTTPServerBuilder
    if let tlsConfiguration = try arguments.tlsConfiguration {
        server = try .tls(tlsConfiguration: tlsConfiguration)
    } else {
        server = .http1()
    }

    let application = Application(
        router: router,
        server: server,
        configuration: .init(
            address: arguments.bindAddress,
            serverName: "swift-birdhouse"
        ),
        logger: logger
    )
    return application
}

extension ApplicationArguments {

    var bindAddress: BindAddress {
        return .hostname(hostname, port: port)
    }

    var baseURL: URL {
        get throws {
            var baseURL = URLComponents()
            baseURL.scheme = "http"
            baseURL.host = hostname
            baseURL.port = port
            guard let url = baseURL.url else {
                throw ApplicationArgumentsError.malformedURL(host: hostname, port: port)
            }
            return url
        }
    }

    var tlsConfiguration: TLSConfiguration? {
        get throws {
            guard let certificatePath, let privateKeyPath else {
                return nil
            }
            let certificate = try NIOSSLCertificate.fromPEMFile(certificatePath)
            let privateKey = try NIOSSLPrivateKey(file: privateKeyPath, format: .pem)
            return TLSConfiguration.makeServerConfiguration(
                certificateChain: certificate.map { .certificate($0) },
                privateKey: .privateKey(privateKey)
            )
        }
    }

}

enum ApplicationArgumentsError: Error {
    case malformedURL(host: String, port: Int)
}
