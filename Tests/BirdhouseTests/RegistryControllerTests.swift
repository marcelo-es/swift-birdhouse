import Foundation
import Hummingbird
import HummingbirdTesting
import Testing

@testable import Birdhouse

struct RegistryControllerTests {

    @Test func addsRoutes() throws {

        let baseURL = URL(string: "http://mock.url")!
        let repository = MemoryReleaseRepository(releases: [])
        let testSubject = RegistryController<MemoryReleaseRepository>(baseURL: baseURL, repository: repository)

        // WHEN initializing the controller and adding routes to the router
        let router = Router()
        testSubject.addRoutes(to: router)

        // THEN there are 6 routes
        let routes = router.routes
        #expect(routes.count == 6)

        // AND one route for the list package releases endpoint
        #expect(routes.contains { $0.path.description == "/{scope}/{name}" && $0.method == .get })

        // AND one route for the fetch release metadata endpoint
        #expect(routes.contains { $0.path.description == "/{scope}/{name}/{version}" && $0.method == .get })

        // AND one route for the fetch manifest for package release endpoint
        #expect(
            routes.contains { $0.path.description == "/{scope}/{name}/{version}/Package.swift" && $0.method == .get })

        // AND one route for the download source archive endpoint
        #expect(routes.contains { $0.path.description == "/{scope}/{name}/{version}.zip" && $0.method == .get })

        // AND one route for the lookup package identifiers by URL endpoint
        #expect(routes.contains { $0.path.description == "/identifiers" && $0.method == .get })

        // AND one route for the publish package release endpoint
        #expect(routes.contains { $0.path.description == "/{scope}/{name}/{version}" && $0.method == .put })

    }

}
