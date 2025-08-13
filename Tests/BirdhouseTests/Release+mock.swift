import Foundation

@testable import Birdhouse

extension Set<Release> {

    static func mock() -> Self {
        [
            Release(
                id: UUID(uuidString: "022D805C-4726-4F23-9A6B-11BEE3FBBB34")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.0.0",
                sourceArchive: Data(),
                publishedAt: Date()
            ),
            Release(
                id: UUID(uuidString: "3D550E25-62AD-4CE1-A2FF-F9B626603FDD")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.1.0",
                sourceArchive: Data(),
                publishedAt: Date()
            ),
            Release(
                id: UUID(uuidString: "9B595D15-3E5C-46A8-B770-D8EF9346C132")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.1.1",
                sourceArchive: Data(),
                publishedAt: Date()
            ),
        ]
    }

}
