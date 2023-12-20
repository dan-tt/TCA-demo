// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OnlineShop",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Common",
            targets: ["Common"]
        ),
        .library(
            name: "Products",
            targets: ["Products"]
        ),
        .library(
            name: "Carts",
            targets: ["Carts"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.5.3"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Common",
            dependencies: []
        ),
        .target(
            name: "Products",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                "Common",
                "Carts"
            ]
        ),
        .testTarget(
            name: "ProductTests",
            dependencies: [
                "Common",
                "Products"
            ]
        ),
        .target(
            name: "Carts",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Common"
            ]
        ),
        .testTarget(
            name: "CartsTests",
            dependencies: [
                "Carts"
            ]
        ),
    ]
)
