// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DotaFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "DotaFeature", targets: ["DotaFeature"])],
    dependencies: [
        .package(path: "../DotaFoundation"),
        .package(path: "../HeroListFeature"),
        .package(path: "../HeroDetailFeature"),
        .package(url: "https://github.com/anthony1810/ScreenStateKit.git", from: "1.3.0")
    ],
    targets: [
        .target(name: "DotaFeature", dependencies: [
            "DotaFoundation", "HeroListFeature", "HeroDetailFeature",
            .product(name: "ScreenStateKit", package: "ScreenStateKit")
        ]),
        .testTarget(name: "DotaFeatureTests", dependencies: ["DotaFeature"])
    ]
)
