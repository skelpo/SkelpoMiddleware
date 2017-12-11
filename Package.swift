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
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/jwt-provider.git", .exact("1.3.0"))
    ],
    targets: [
    .target(name: "SkelpoMiddleware", dependencies: ["Helpers", "AuthMiddleware", "APIMiddleware"]),
        .target(name: "APIMiddleware", dependencies: ["Store", "Helpers", "Vapor"]),
        .target(name: "AuthMiddleware", dependencies: ["Store", "Helpers", "Vapor", "JWTProvider"]),
        .target(name: "Helpers", dependencies: ["Store", "Vapor", "JWTProvider"]),
        .target(name: "Store", dependencies: ["Vapor", "JWTProvider"]),
        .testTarget(name: "SkelpoMiddlewareTests", dependencies: ["APIMiddleware"]),
    ]
)
