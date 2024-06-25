@testable import SwiftRegistry
import Foundation

extension Set<Release> {

    static func mock() -> Self {
        [
            Release(
                id: UUID(uuidString: "022D805C-4726-4F23-9A6B-11BEE3FBBB34")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.0.0",
                problem: nil
            ),
            Release(
                id: UUID(uuidString: "3D550E25-62AD-4CE1-A2FF-F9B626603FDD")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.1.0",
                problem: Problem(
                    type: nil,
                    title: "Gone",
                    status: 410,
                    detail: "this release was removed from the registry",
                    instance: nil
                )
            ),
            Release(
                id: UUID(uuidString: "9B595D15-3E5C-46A8-B770-D8EF9346C132")!,
                scope: "mona",
                name: "LinkedList",
                version: "1.1.1",
                problem: nil
            ),
        ]
    }

}
