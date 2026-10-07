// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Lumen",
    platforms: [.macOS(.v26)],
    products: [
        .library(name: "LumenCore", targets: ["LumenCore"]),
        .executable(name: "LumenApp", targets: ["LumenApp"])
    ],
    targets: [
        .target(name: "LumenCore"),
        .executableTarget(name: "LumenApp", dependencies: ["LumenCore"]),
        .testTarget(name: "LumenTests", dependencies: ["LumenCore"])
    ]
)
