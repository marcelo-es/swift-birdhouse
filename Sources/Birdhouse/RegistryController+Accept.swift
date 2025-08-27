import HTTPTypes

extension RegistryController {

    enum APIVersion: String {
        case v1
    }

    enum MediaType: String {
        case json
        case zip
        case swift
    }

    /// A client SHOULD set the Accept header field to specify the API version of a request.
    ///
    /// GET /mona/LinkedList/list HTTP/1.1
    /// Host: packages.example.com
    /// Accept: application/vnd.swift.registry.v1+json
    ///
    /// Valid Accept header field values are described by the following rules:
    ///   version     = "1"       ; The API version
    ///   mediatype   = "json" /  ; JSON (default media type)
    ///                 "zip"  /  ; Zip archives, used for package releases
    ///                 "swift"   ; Swift file, used for package manifest
    ///   accept      = "application/vnd.swift.registry" [".v" version] ["+" mediatype]
    func assertAccept(
        headers: HTTPFields,
        apiVersion: APIVersion = .v1,
        mediaType: MediaType
    ) throws {
        guard let value = headers[.accept] else {
            throw Problem(status: .badRequest, detail: "Missing Accept header")
        }

        let regex = /^application\/vnd\.swift\.registry\.(?<version>v\d+)\+(?<mediaType>\w+)$/
        guard let match = try? regex.wholeMatch(in: value) else {
            throw Problem(status: .badRequest, detail: "Unsupported Accept header")
        }

        guard let headerVersion = APIVersion(rawValue: String(match.output.version)) else {
            throw Problem(status: .badRequest, detail: "Invalid API version")
        }

        guard headerVersion == apiVersion else {
            throw Problem(status: .unsupportedMediaType, detail: "Unsupported API version")
        }

        guard let headerMediaType = MediaType(rawValue: String(match.output.mediaType)),
            headerMediaType == mediaType
        else {
            throw Problem(status: .unsupportedMediaType, detail: "Unsupported media type")
        }
    }

}
