// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftRegistry",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.1"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftRegistry",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
