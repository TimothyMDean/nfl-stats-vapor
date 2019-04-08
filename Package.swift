// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "nfl\u{2D}stats\u{2D}vapor",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),
        .package(url: "https://github.com/vapor/fluent\u{2D}sqlite.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
