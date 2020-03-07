// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "WQCharts",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(
            name: "WQCharts",
            targets: ["WQCharts"]),
    ],
    targets: [
        .target(
            name: "WQCharts",
            path: "WQCharts/Classes"
        )
    ],
    swiftLanguageVersions: [.v5]
    
)
