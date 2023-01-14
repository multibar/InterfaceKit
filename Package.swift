// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InterfaceKit",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "InterfaceKit",
            targets: ["InterfaceKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/multibar/CoreKit.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/kean/Nuke.git",
            from: "11.5.3"
        ),
        .package(
            url: "https://github.com/airbnb/lottie-ios.git",
            from: "4.0.1"
        ),
        .package(
            url: "https://github.com/devicekit/DeviceKit.git",
            from: "5.0.0"
        )
    ],
    targets: [
        .target(
            name: "InterfaceKit",
            dependencies: [
                .product(name: "CoreKit", package: "CoreKit"),
                .product(name: "DeviceKit", package: "DeviceKit"),
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "NukeExtensions", package: "Nuke"),
                .product(name: "Lottie", package: "lottie-ios")
            ],
            resources: [
                .process("Resources/Assets/chevron_left.pdf"),
                .process("Resources/Assets/chevron_down.pdf")
            ]
        ),
        .testTarget(
            name: "InterfaceKitTests",
            dependencies: ["InterfaceKit"]),
    ]
)
