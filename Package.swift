// swift-tools-version:4.0
import PackageDescription
let package = Package(
    name: "SkelpoMiddleware",
    products: [
        .library(name: "APIMiddleware", targets: ["APIMiddleware"]),
        .library(name: "AuthMiddleware", targets: ["AuthMiddleware"]),
        .library(name: "SkelpoMiddleware", targets: ["SkelpoMiddleware"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .branch("beta")),
        .package(url: "https://github.com/vapor/jwt.git", .branch("beta")),
        .package(url: "https://github.com/vapor/auth.git", .branch("beta"))
    ],
    targets: [
        .target(name: "SkelpoMiddleware", dependencies: ["Errors", "Helpers", "AuthMiddleware", "APIMiddleware"]),
        .target(name: "AuthMiddleware", dependencies: ["Errors", "Helpers", "Vapor", "JWT", "Authentication"]),
        .target(name: "APIMiddleware", dependencies: ["Errors", "Helpers", "Vapor"]),
        .target(name: "Helpers", dependencies: ["Errors", "Vapor", "JWT", "Authentication"]),
        .target(name: "Errors", dependencies: ["Vapor", "JWT"]),
        .testTarget(name: "SkelpoMiddlewareTests", dependencies: ["APIMiddleware"]),
    ]
)
