// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftBirdhouse",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "swift-birdhouse", targets: ["Command"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.1"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.12.3"),
        .package(url: "https://github.com/apple/swift-http-structured-headers", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.6.3"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.33.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.15.0"),
        .package(url: "https://github.com/vapor/multipart-kit", from: "4.7.1"),
        .package(url: "https://github.com/vapor-community/Zip", from: "2.2.6"),
    ],
    targets: [
        .executableTarget(
            name: "Command",
            dependencies: [
                .target(name: "Birdhouse"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
            ]
        ),
        .target(
            name: "Birdhouse",
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdCore", package: "hummingbird"),
                .product(name: "HummingbirdTLS", package: "hummingbird"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "MultipartKit", package: "multipart-kit"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Zip", package: "zip"),
            ]
        ),
        .testTarget(
            name: "BirdhouseTests",
            dependencies: [
                .target(name: "Birdhouse"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "StructuredFieldValues", package: "swift-http-structured-headers"),
            ]
        ),
    ]
)
