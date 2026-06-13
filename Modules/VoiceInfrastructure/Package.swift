// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "VoiceInfrastructure",
    platforms: [.iOS("26.0"), .macOS("26.0")],
    products: [.library(name: "VoiceInfrastructure", targets: ["VoiceInfrastructure"])],
    dependencies: [
        .package(path: "../DotaFoundation")
    ],
    targets: [
        .target(name: "VoiceInfrastructure", dependencies: ["DotaFoundation"]),
        .testTarget(name: "VoiceInfrastructureTests", dependencies: ["VoiceInfrastructure", "DotaFoundation"])
    ],
    swiftLanguageModes: [.v6]
)
