import Testing

@testable import Birdhouse

@Suite("Accept Header Tests")
struct AcceptHeaderTests {

    @Test("v1 JSON")
    func v1Json() throws {
        let header = try AcceptHeader("application/vnd.swift.registry.v1+json")
        #expect(header.mediaType == .json)
        #expect(header.version == .v1)
    }

    @Test("v1 zip")
    func v1Zip() throws {
        let header = try AcceptHeader("application/vnd.swift.registry.v1+zip")
        #expect(header.mediaType == .zip)
        #expect(header.version == .v1)
    }

    @Test("v1 Swift")
    func v1Swift() throws {
        let header = try AcceptHeader("application/vnd.swift.registry.v1+swift")
        #expect(header.mediaType == .swift)
        #expect(header.version == .v1)
    }

    @Test("Malformed header")
    func malformedHeader() throws {
        let value = "application/json"
        #expect(throws: AcceptHeader.Error.malformedHeader(value)) {
            try AcceptHeader(value)
        }
    }

    @Test("Invalid version")
    func invalidVersion() throws {
        let value = "application/vnd.swift.registry.v2+json"
        #expect(throws: AcceptHeader.Error.invalidVersion("v2")) {
            try AcceptHeader(value)
        }
    }

    @Test("Unsupported media type")
    func unsupportedMediaType() throws {
        let value = "application/vnd.swift.registry.v1+excel"
        #expect(throws: AcceptHeader.Error.unsupportedMediaType("excel")) {
            try AcceptHeader(value)
        }
    }

}
