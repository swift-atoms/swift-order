// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-order",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Order",
            targets: ["Order"]
        ),
        .library(
            name: "Order Standard Library Integration",
            targets: ["Order Standard Library Integration"]
        ),
        .library(
            name: "Order Apple Foundation Integration",
            targets: ["Order Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Order",
            dependencies: []
        ),
        .target(
            name: "Order Standard Library Integration",
            dependencies: ["Order"]
        ),
        .target(
            name: "Order Apple Foundation Integration",
            dependencies: [
                "Order",
                "Order Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Order Tests",
            dependencies: ["Order"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
