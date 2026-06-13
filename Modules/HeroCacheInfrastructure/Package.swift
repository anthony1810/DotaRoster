// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HeroCacheInfrastructure",
    platforms: [.iOS("26.0"), .macOS("26.0")],
    products: [.library(name: "HeroCacheInfrastructure", targets: ["HeroCacheInfrastructure"])],
    dependencies: [
        .package(path: "../DotaFoundation")
    ],
    targets: [
        .target(name: "HeroCacheInfrastructure", dependencies: ["DotaFoundation"]),
        .testTarget(name: "HeroCacheInfrastructureTests", dependencies: ["HeroCacheInfrastructure", "DotaFoundation"])
    ],
    swiftLanguageModes: [.v6]
)
