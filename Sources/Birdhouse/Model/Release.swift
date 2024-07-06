import Foundation

struct Release: Hashable {

    /// Package ID
    let id: UUID

    /// Scope of the package
    let scope: String

    /// Name of the package
    let name: String

    /// Version of the release
    let version: String

    /// Details of a problem with this release
    let problem: Problem?

    /// Source archive of the release
    let sourceArchive: Data

}
