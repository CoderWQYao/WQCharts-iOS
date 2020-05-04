// https://github.com/CoderWQYao/WQCharts-iOS
//
// Package.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import PackageDescription

let package = Package(
    
    name: "WQCharts",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(
            name: "WQCharts",
            targets: ["WQCharts"]
        ),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "WQCharts",
            path: "WQCharts/Classes"
        ),
    ],
    swiftLanguageVersions: [.v5]
    
)
