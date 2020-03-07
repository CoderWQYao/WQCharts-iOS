// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WQCharts",
    products: [
        .library(
            name: "WQCharts",
            targets: ["WQCharts"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CoderWQYao/WQCharts-iOS.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WQCharts",
            dependencies: [],
            path: "WQCharts/Classes"
        )
    ]
)
