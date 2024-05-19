import Hummingbird
import OpenAPIHummingbird

func buildApplication(configuration: ApplicationConfiguration) throws -> some ApplicationProtocol {
    let router = Router()

    router.middlewares.add(LogRequestsMiddleware(.info, includeHeaders: true))

    let api = SwiftRegistryAPI()
    try api.registerHandlers(on: router)

    let application = Application(
        router: router,
        configuration: configuration
    )
    return application
}
