// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SkelpoMiddleware",
    products: [
        .library(name: "APIMiddleware", targets: ["APIMiddleware"]),
        .library(name: "SkelpoMiddleware", targets: ["SkelpoMiddleware"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/skelpo/JWTVapor.git", from: "0.7.0"),
        .package(url: "https://github.com/skelpo/JWTMiddleware.git", from: "0.3.0"),
        .package(url: "https://github.com/skelpo/APIErrorMiddleware.git", from: "0.1.0"),
        .package(url: "https://github.com/skelpo/vapor-request-storage", from: "0.1.0")
    ],
    targets: [
        .target(name: "SkelpoMiddleware", dependencies: ["JWTMiddleware", "APIMiddleware", "APIErrorMiddleware"]),
        .target(name: "APIMiddleware", dependencies: ["Vapor", "VaporRequestStorage", "JWTMiddleware"]),
        .testTarget(name: "SkelpoMiddlewareTests", dependencies: ["APIMiddleware"]),
    ]
)
