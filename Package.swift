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
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc"),
        .package(url: "https://github.com/skelpo/JWTVapor.git,", from: "0.3.0"),
        .package(url: "https://github.com/skelpo/JWTMiddleware.git", from: "0.3.0"),
        .package(url: "https://github.com/skelpo/APIErrorMiddleware.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "SkelpoMiddleware", dependencies: ["Errors", "Helpers", "JWTMiddleware", "APIMiddleware", "JWTVapor", "APIErrorMiddleware"]),
        .target(name: "APIMiddleware", dependencies: ["Errors", "Helpers", "Vapor"]),
        .target(name: "Helpers", dependencies: ["Errors", "Vapor", "JWT", "Authentication"]),
        .target(name: "Errors", dependencies: ["Vapor", "JWT"]),
        .testTarget(name: "SkelpoMiddlewareTests", dependencies: ["APIMiddleware"]),
    ]
)
