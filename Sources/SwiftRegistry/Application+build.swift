import Hummingbird
import Logging
import OpenAPIHummingbird

func buildApplication(_ arguments: ApplicationArguments) throws -> some ApplicationProtocol {
    var logger = Logger(label: "SwiftRegistry")
    logger.logLevel = .debug

    let router = Router()

    router.middlewares.add(LogRequestsMiddleware(.info, includeHeaders: .all()))

    let repository = ReleaseMemoryRepository()
    let api = SwiftRegistryAPI(repository: repository)
    try api.registerHandlers(on: router)

    let application = Application(
        router: router,
        configuration: .init(address: .hostname(arguments.hostname, port: arguments.port), serverName: "SwiftRegistry"),
        logger: logger
    )
    return application
}
