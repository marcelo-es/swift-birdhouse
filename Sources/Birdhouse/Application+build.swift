import Foundation
import Hummingbird
import HummingbirdCore
import HummingbirdTLS
import Logging
import NIOSSL

public func buildApplication(
    host: String = "127.0.0.1",
    port: Int = 8080,
    tlsConfiguration: TLSConfiguration? = nil,
    repository: some ReleaseRepository,
    logger: Logger = Logger(label: "swift-birdhouse")
) throws -> some ApplicationProtocol {
    let router = Router()
    router.middlewares.add(LogRequestsMiddleware(.info))

    let registryController = RegistryController(
        baseURL: try baseURL(host, port: port),
        repository: repository
    )
    registryController.addRoutes(to: router)

    let server: HTTPServerBuilder =
        if let tlsConfiguration {
            try .tls(tlsConfiguration: tlsConfiguration)
        } else {
            .http1()
        }

    let application = Application(
        router: router,
        server: server,
        configuration: .init(address: .hostname(host, port: port), serverName: "swift-birdhouse"),
        logger: logger
    )
    return application
}

private func baseURL(_ host: String, port: Int) throws -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = host
    urlComponents.port = port
    guard let url = urlComponents.url else {
        throw BirdhouseError.malformedURL(host: host, port: port)
    }
    return url
}

enum BirdhouseError: Error, LocalizedError {
    case malformedURL(host: String, port: Int)

    var errorDescription: String? {
        switch self {
        case .malformedURL(let host, let port):
            return "The URL with host \(host) and port \(port) is malformed."
        }
    }
}
