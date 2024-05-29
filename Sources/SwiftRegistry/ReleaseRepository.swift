protocol ReleaseRepository: Sendable {
    
    /// Creates a new release with the given scope, name, and version.
    func create(scope: String, name: String, version: String) async throws -> Release

    /// Lists all releases with the given scope and name.
    func list(scope: String, name: String) async throws -> [Release]

}
