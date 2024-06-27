import Foundation
import Hummingbird
import Logging
import OpenAPIHummingbird

func buildApplication(_ arguments: ApplicationArguments) throws -> some ApplicationProtocol {
    var logger = Logger(label: "SwiftRegistry")
    logger.logLevel = .debug

    let router = Router()

    router.middlewares.add(LogRequestsMiddleware(.info, includeHeaders: .all()))

    let repository = ReleaseMemoryRepository(releases: .mock())
    let registryController = RegistryController(
        baseURL: try arguments.baseURL,
        repository: repository
    )
    try registryController.registerHandlers(on: router)

    let application = Application(
        router: router,
        configuration: .init(address: arguments.bindAddress, serverName: "SwiftRegistry"),
        logger: logger
    )
    return application
}

extension Set<Release> {
    
    static func mock() -> Self {
        [
            Release(
                id: UUID(uuidString: "022D805C-4726-4F23-9A6B-11BEE3FBBB34")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.0.0",
                problem: nil
            ),
            Release(
                id: UUID(uuidString: "3D550E25-62AD-4CE1-A2FF-F9B626603FDD")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.1.0",
                problem: Problem(
                    type: nil,
                    title: "Gone",
                    status: 410,
                    detail: "this release was removed from the registry",
                    instance: nil
                )
            ),
            Release(
                id: UUID(uuidString: "9B595D15-3E5C-46A8-B770-D8EF9346C132")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.1.1",
                problem: nil
            ),
        ]
    }

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

}

enum ApplicationArgumentsError: Error {
    case malformedURL(host: String, port: Int)
}
