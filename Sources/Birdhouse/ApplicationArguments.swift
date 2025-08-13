public protocol ApplicationArguments {

    /// Hostname to bind to
    var hostname: String { get }

    /// Port to bind to
    var port: Int { get }

    /// Use in-memory testing
    var inMemoryTesting: Bool { get }

    /// Certificate chain file path
    var certificatePath: String? { get }

    /// Private key file path
    var privateKeyPath: String? { get }

}
