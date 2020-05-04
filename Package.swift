// swift-tools-version:5.0
import PackageDescription

let package = Package(
    
    name: "WQCharts",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(
            name: "WQCharts",
            targets: ["WQCharts"])
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "WQCharts",
            path: "WQCharts/Classes")
    ],
    swiftLanguageVersions: [.v5]
    
)
