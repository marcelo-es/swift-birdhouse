// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftRegistry",
    platforms: [ .macOS(.v14) ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.1"),
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
    ]
)
