// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftBirdhouse",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "birdhouse", targets: ["Birdhouse"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.3.1"),
        .package(url: "https://github.com/apple/swift-log", from: "1.6.1"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.5.0"),
        .package(url: "https://github.com/vapor/multipart-kit", from: "4.7.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.19"),
    ],
    targets: [
        .executableTarget(
            name: "Birdhouse",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdCore", package: "hummingbird"),
                .product(name: "HummingbirdTLS", package: "hummingbird"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "MultipartKit", package: "multipart-kit"),
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
            ]
        ),
        .testTarget(
            name: "BirdhouseTests",
            dependencies: [
                .byName(name: "Birdhouse"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
            ]
        ),
    ]
)
