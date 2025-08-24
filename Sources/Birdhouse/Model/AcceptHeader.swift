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
struct AcceptHeader {

    enum Version: String {
        case v1
    }

    enum MediaType: String {
        case json
        case zip
        case swift
    }

    /// The API version requested by the client.
    let version: Version

    /// The media type requested by the client.
    let mediaType: MediaType

    /// Initialize an AcceptHeader from a string value.
    init(_ value: String) throws {
        let regex = /^application\/vnd\.swift\.registry\.(?<version>v\d+)\+(?<mediaType>\w+)$/
        guard let match = try? regex.wholeMatch(in: value) else {
            throw Error.malformedHeader(value)
        }

        guard let version = Version(rawValue: String(match.output.version)) else {
            throw Error.invalidVersion(String(match.output.version))
        }

        guard let mediaType = MediaType(rawValue: String(match.output.mediaType)) else {
            throw Error.unsupportedMediaType(String(match.output.mediaType))
        }

        self.version = version
        self.mediaType = mediaType
    }

}

extension AcceptHeader {

    enum Error: Swift.Error, Equatable {
        case malformedHeader(String)
        case invalidVersion(String)
        case unsupportedMediaType(String)
    }

}
