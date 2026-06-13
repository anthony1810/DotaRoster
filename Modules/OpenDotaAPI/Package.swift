// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "OpenDotaAPI",
    platforms: [.iOS("26.0"), .macOS("26.0")],
    products: [.library(name: "OpenDotaAPI", targets: ["OpenDotaAPI"])],
    dependencies: [
        .package(path: "../DotaFoundation"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", from: "1.0.0")
    ],
    targets: [
        .target(name: "OpenDotaAPI", dependencies: [
            "DotaFoundation",
            .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")
        ]),
        .testTarget(name: "OpenDotaAPITests", dependencies: ["OpenDotaAPI", "DotaFoundation"])
    ],
    swiftLanguageModes: [.v6]
)
