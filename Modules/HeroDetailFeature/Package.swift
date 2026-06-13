// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HeroDetailFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "HeroDetailFeature", targets: ["HeroDetailFeature"])],
    dependencies: [
        .package(path: "../DotaFoundation"),
        .package(path: "../HeroListFeature"),
        .package(url: "https://github.com/anthony1810/ScreenStateKit.git", from: "1.3.0"),
        .package(url: "https://github.com/pointfreeco/swift-clocks", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.0.0")
    ],
    targets: [
        .target(name: "HeroDetailFeature", dependencies: [
            "DotaFoundation", "HeroListFeature",
            .product(name: "ScreenStateKit", package: "ScreenStateKit"),
            .product(name: "Clocks", package: "swift-clocks"),
            .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")
        ]),
        .testTarget(name: "HeroDetailFeatureTests", dependencies: [
            "HeroDetailFeature", "DotaFoundation",
            .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")
        ])
    ]
)
