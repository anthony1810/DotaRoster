// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HeroCacheInfrastructure",
    platforms: [.iOS("26.0"), .macOS("26.0")],
    products: [.library(name: "HeroCacheInfrastructure", targets: ["HeroCacheInfrastructure"])],
    dependencies: [
        .package(path: "../DotaFoundation"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", from: "1.0.0")
    ],
    targets: [
        .target(name: "HeroCacheInfrastructure", dependencies: ["DotaFoundation"]),
        .testTarget(
            name: "HeroCacheInfrastructureTests",
            dependencies: [
                "HeroCacheInfrastructure",
                "DotaFoundation",
                .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
