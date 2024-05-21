@testable import SwiftRegistry
import RegistryAPI
import XCTest

final class RegistryAPI_listPackageReleasesTests: XCTestCase {

    typealias Input = Operations.listPackageReleases.Input
    typealias Output = Operations.listPackageReleases.Output

    var testSubject: SwiftRegistryAPI<ReleaseMemoryRepository>!

    func testListPackageReleases() async throws {
        testSubject = .init(repository: ReleaseMemoryRepository())

        let input = Input(
            path: .init(scope: "mona", name: "LinkedList"),
            headers: .init(accept: .defaultValues())
        )
        let output = try await testSubject.listPackageReleases(input)
    }

}
