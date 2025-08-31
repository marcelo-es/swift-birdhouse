import Foundation

@testable import Birdhouse

extension Release {

    static func mock(
        id: String = "F891D03C-0031-4A5E-98A4-608FE7804C4D",
        scope: String = "mona",
        name: String = "LinkedList",
        version: String = "1.0.0",
        sourceArchive: Data = Data(),
        publishedAt: Date = Date()
    ) -> Self {
        Release(
            id: UUID(uuidString: id)!,
            scope: scope,
            name: name,
            version: version,
            sourceArchive: sourceArchive,
            publishedAt: publishedAt
        )
    }

}

extension [Release] {

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
            Release(
                id: UUID(uuidString: "D58D5062-7E59-4402-BDD0-3B15D5119D46")!,
                scope: "mona",
                name: "Tree",
                version: "1.0.0",
                sourceArchive: Data(),
                publishedAt: Date()
            ),
            Release(
                id: UUID(uuidString: "01AB1B56-CF49-4A9E-868A-D7CE40909DAC")!,
                scope: "lisa",
                name: "BubbleSort",
                version: "2.0.0",
                sourceArchive: Data(),
                publishedAt: Date()
            ),
        ]
    }

}
