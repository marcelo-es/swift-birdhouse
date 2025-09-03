import Foundation

public struct Release: Hashable, Sendable {

    /// Package ID
    let id: UUID

    /// Scope of the package
    let scope: String

    /// Name of the package
    let name: String

    /// Version of the release
    let version: String

    /// Source archive of the release
    let sourceArchive: Data

    /// When the release was published
    let publishedAt: Date

    /// Additional information about the release
    let metadata: Metadata?

}
