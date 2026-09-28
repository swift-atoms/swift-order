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

        .library(name: "Order Foundation Integration", targets: ["Order Foundation Integration"]),
        .library(name: "Order Test Support", targets: ["Order Test Support"]),
    ],
    traits: [
        .trait(name: "Property", description: "Property integration"),
        .trait(name: "Finite", description: "Finite integration"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ordinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-index.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-finite.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),

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
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Finite"])),
                .product(name: "Ordinal", package: "swift-ordinal", condition: .when(traits: ["Finite"])),
                .product(name: "Index", package: "swift-index", condition: .when(traits: ["Finite"])),
                .product(name: "Finite", package: "swift-finite", condition: .when(traits: ["Finite"])),
                .product(name: "Cardinal", package: "swift-cardinal", condition: .when(traits: ["Finite"])),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
            ],
            path: "Sources/Order"
        ),
        
        .target(
            name: "Order Foundation Integration",
            dependencies: [
                .target(name: "Order"),
            ],
            path: "Sources/Order Foundation Integration"
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
                .target(name: "Order Test Support"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
                .target(name: "Order Foundation Integration"),
            ],
            path: "Tests/Order Tests"
        ),
        .testTarget(
            name: "Consolidated Order Comparison Tests",
            dependencies: [

                .target(name: "Order"),
                .product(name: "Comparison", package: "swift-comparison"),
            ],
            path: "Tests/Consolidated swift-order-comparison"
        ),
        .testTarget(
            name: "Order Finite Tests",
            dependencies: [
                .target(name: "Order"),
                .target(name: "Order Test Support"),
                .product(name: "Cardinal", package: "swift-cardinal", condition: .when(traits: ["Finite"])),
                .product(name: "Finite", package: "swift-finite", condition: .when(traits: ["Finite"])),
                .product(name: "Index", package: "swift-index", condition: .when(traits: ["Finite"])),
                .product(name: "Ordinal", package: "swift-ordinal", condition: .when(traits: ["Finite"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Finite"])),
            ],
            path: "Tests/Order Finite Tests"
        ),
        .testTarget(name: "Order Owned Property Migration Tests", dependencies: [
            .target(name: "Order"),
            .product(name: "Comparison", package: "swift-comparison", condition: .when(traits: ["Property"])),
            .product(name: "Property", package: "swift-property", condition: .when(traits: ["Property"])),
        ], path: "Tests/Order Owned Property Migration Tests"),
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
