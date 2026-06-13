// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DotaFoundation",
    platforms: [.iOS("26.0"), .macOS("26.0")],
    products: [.library(name: "DotaFoundation", targets: ["DotaFoundation"])],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", from: "1.0.0")
    ],
    targets: [
        .target(name: "DotaFoundation", dependencies: [
            .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")
        ]),
        .testTarget(name: "DotaFoundationTests", dependencies: ["DotaFoundation"])
    ],
    swiftLanguageModes: [.v6]
)
