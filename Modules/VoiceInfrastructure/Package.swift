// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VoiceInfrastructure",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "VoiceInfrastructure", targets: ["VoiceInfrastructure"])],
    dependencies: [
        .package(path: "../DotaFoundation")
    ],
    targets: [
        .target(name: "VoiceInfrastructure", dependencies: ["DotaFoundation"]),
        .testTarget(name: "VoiceInfrastructureTests", dependencies: ["VoiceInfrastructure", "DotaFoundation"])
    ]
)
