// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DotaConstantsAPI",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "DotaConstantsAPI", targets: ["DotaConstantsAPI"])],
    dependencies: [
        .package(path: "../DotaFoundation"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", from: "1.0.0")
    ],
    targets: [
        .target(name: "DotaConstantsAPI", dependencies: [
            "DotaFoundation",
            .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")
        ]),
        .testTarget(name: "DotaConstantsAPITests", dependencies: ["DotaConstantsAPI", "DotaFoundation"])
    ]
)
