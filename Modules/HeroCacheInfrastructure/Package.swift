// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HeroCacheInfrastructure",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "HeroCacheInfrastructure", targets: ["HeroCacheInfrastructure"])],
    dependencies: [
        .package(path: "../DotaFoundation")
    ],
    targets: [
        .target(name: "HeroCacheInfrastructure", dependencies: ["DotaFoundation"]),
        .testTarget(name: "HeroCacheInfrastructureTests", dependencies: ["HeroCacheInfrastructure", "DotaFoundation"])
    ]
)
