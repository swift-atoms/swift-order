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
            name: "Order Direction",
            targets: ["Order Direction"]
        ),
        .library(
            name: "Order Monotonicity",
            targets: ["Order Monotonicity"]
        ),
        .library(
            name: "Order Comparator",
            targets: ["Order Comparator"]
        ),
        .library(
            name: "Order Orderable",
            targets: ["Order Orderable"]
        ),
        .library(
            name: "Order Projection",
            targets: ["Order Projection"]
        ),

        .library(
            name: "Order Standard Library Integration",
            targets: ["Order Standard Library Integration"]
        ),

        .library(
            name: "Order",
            targets: ["Order"]
        ),

        .library(
            name: "Order Test Support",
            targets: ["Order Test Support"]
        ),
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
            dependencies: []
        ),

        .target(
            name: "Order Direction",
            dependencies: [
                .target(name: "Order")
            ]
        ),
        .target(
            name: "Order Monotonicity",
            dependencies: [
                .target(name: "Order"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Order Comparator",
            dependencies: [
                .target(name: "Order"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Comparison Protocol", package: "swift-comparison"),
            ]
        ),
        .target(
            name: "Order Orderable",
            dependencies: [
                .target(name: "Order"),
                .target(name: "Order Comparator"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Comparison Protocol", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Property Inout", package: "swift-property"),
            ]
        ),
        .target(
            name: "Order Projection",
            dependencies: [
                .target(name: "Order"),
                .target(name: "Order Direction"),
                .target(name: "Order Comparator"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Comparison Protocol", package: "swift-comparison"),
            ]
        ),

        .target(
            name: "Order Standard Library Integration",
            dependencies: [
                .target(name: "Order Comparator"),
                .target(name: "Order Orderable"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Property Inout", package: "swift-property"),
            ]
        ),

        .target(
            name: "Order Test Support",
            dependencies: [
                .target(name: "Order"),
                .product(
                    name: "Property Test Support",
                    package: "swift-property"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Order Tests",
            dependencies: [
                .target(name: "Order"),
                .target(name: "Order Comparator"),
                .target(name: "Order Direction"),
                .target(name: "Order Orderable"),
                .target(name: "Order Projection"),
                .target(name: "Order Standard Library Integration"),
                .target(name: "Order Test Support"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Comparison Protocol", package: "swift-comparison"),
                .product(
                    name: "Comparison Standard Library Integration",
                    package: "swift-comparison"
                ),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Property Inout", package: "swift-property"),
            ]
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
