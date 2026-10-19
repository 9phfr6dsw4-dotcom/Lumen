// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Lumen",
    platforms: [.macOS(.v26)],
    products: [
        .library(name: "LumenCore", targets: ["LumenCore"]),
        .executable(name: "LumenApp", targets: ["LumenApp"])
    ],
    dependencies: [
        // Automatic updates. Pinned exactly; the packaged app embeds this framework.
        .package(url: "https://github.com/sparkle-project/Sparkle", exact: "2.10.0")
    ],
    targets: [
        .target(name: "LumenCore"),
        .executableTarget(
            name: "LumenApp",
            dependencies: [
                "LumenCore",
                .product(name: "Sparkle", package: "Sparkle")
            ],
            linkerSettings: [
                // The packaged app keeps Sparkle.framework in Contents/Frameworks.
                .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", "@executable_path/../Frameworks"])
            ]
        ),
        .testTarget(name: "LumenTests", dependencies: ["LumenCore"])
    ]
)
