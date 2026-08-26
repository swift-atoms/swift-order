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
            name: "Order Primitive",
            targets: ["Order Primitive"]
        ),

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
            url: "https://github.com/swift-molecules/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-property.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-pair.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Order Primitive",
            dependencies: []
        ),

        .target(
            name: "Order Direction",
            dependencies: [
                "Order Primitive"
            ]
        ),
        .target(
            name: "Order Monotonicity",
            dependencies: [
                "Order Primitive",
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Order Comparator",
            dependencies: [
                "Order Primitive",
                .product(name: "Comparison", package: "swift-comparison"),
            ]
        ),
        .target(
            name: "Order Orderable",
            dependencies: [
                "Order Primitive",
                "Order Comparator",
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
            ]
        ),
        .target(
            name: "Order Projection",
            dependencies: [
                "Order Primitive",
                "Order Direction",
                "Order Comparator",
                .product(name: "Comparison", package: "swift-comparison"),
            ]
        ),

        .target(
            name: "Order Standard Library Integration",
            dependencies: [
                "Order Comparator",
                "Order Orderable",
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
            ]
        ),

        .target(
            name: "Order",
            dependencies: [
                "Order Primitive",
                "Order Direction",
                "Order Monotonicity",
                "Order Comparator",
                "Order Orderable",
                "Order Projection",
                "Order Standard Library Integration",
            ]
        ),

        .target(
            name: "Order Test Support",
            dependencies: [
                "Order",
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
                "Order",
                "Order Test Support",
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
