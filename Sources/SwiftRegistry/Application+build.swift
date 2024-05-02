import Hummingbird

func buildApplication(configuration: ApplicationConfiguration) -> some ApplicationProtocol {
    let router = Router()
    router.get("/") { _, _ in
        return "Hello"
    }

    let application = Application(
        router: router,
        configuration: configuration
    )
    return application
}
