// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftRegistry",
    platforms: [ .macOS(.v14) ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.1"),
        .package(url: "https://github.com/apple/swift-log", from: "1.5.4"),
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.2.1"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.2.1"),
        .package(url: "https://github.com/swift-server/swift-openapi-hummingbird", from: "2.0.0-beta.1"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.0.0-beta.6"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftRegistry",
            dependencies: [
                .byName(name: "RegistryAPI"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "OpenAPIHummingbird", package: "swift-openapi-hummingbird"),
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
            ]
        ),
        .target(
            name: "RegistryAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            resources: [
                .copy("openapi.yaml"),
                .copy("openapi-generator-config.yaml"),
            ]
        ),
        .testTarget(
            name: "SwiftRegistryTests",
            dependencies: [
                .byName(name: "SwiftRegistry"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
            ]
        )
    ]
)
