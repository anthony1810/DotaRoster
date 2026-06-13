// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DotaFeature",
    platforms: [.iOS("26.0"), .macOS("26.0")],
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
    ],
    swiftLanguageModes: [.v6]
)
