import OpenAPIRuntime

extension UndocumentedPayload {

    static func notImplemented() -> Self {
        .init(
            headerFields: [
                .contentType: "application/problem+json",
                .contentLanguage: "en"
            ],
            body: """
            {
                "type": "https://httpstatuses.io/501",
                "title": "Not Implemented",
                "status": 501,
                "detail": "This operation has not been implemented."
            }
            """
        )
    }

}
