// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hlvm",
    dependencies: [
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", from: "0.50300.0")
    ],
    targets: [
        .target(
            name: "hlvm",
            dependencies: ["SwiftSyntax"]
        ),
        .testTarget(
            name: "hlvmTests",
            dependencies: ["hlvm"]),
    ]
)
