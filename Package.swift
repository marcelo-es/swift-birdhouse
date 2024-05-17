// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftRegistry",
    platforms: [ .macOS(.v14) ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.1"),
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.2.1"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.2.1"),
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0-beta.4"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftRegistry",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Hummingbird", package: "hummingbird"),
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
