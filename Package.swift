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
        .library(name: "Order", targets: ["Order"]),
        .library(name: "Order Standard Library Integration", targets: ["Order Standard Library Integration"]),
        .library(name: "Order Foundation Library Integration", targets: ["Order Foundation Library Integration"]),
        .library(name: "Order Test Support", targets: ["Order Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-property.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Order",
            dependencies: [
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
            ],
            path: "Sources/Order"
        ),
        .target(
            name: "Order Standard Library Integration",
            dependencies: [
                .target(name: "Order"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
            ],
            path: "Sources/Order Standard Library Integration"
        ),
        .target(
            name: "Order Foundation Library Integration",
            dependencies: [
                .target(name: "Order"),
                .target(name: "Order Standard Library Integration"),
            ],
            path: "Sources/Order Foundation Library Integration"
        ),
        .target(
            name: "Order Test Support",
            dependencies: [
                .target(name: "Order"),
                .product(name: "Property Test Support", package: "swift-property"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Order Tests",
            dependencies: [
                .target(name: "Order"),
                .target(name: "Order Standard Library Integration"),
                .target(name: "Order Test Support"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Comparison Standard Library Integration", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
                .target(name: "Order Foundation Library Integration"),
            ],
            path: "Tests/Order Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
