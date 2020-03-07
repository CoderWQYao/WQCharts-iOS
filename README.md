# WQCharts

[![CI Status](https://img.shields.io/travis/wqcoder@gmail.com/WQCharts.svg?style=flat)](https://travis-ci.org/wqcoder@gmail.com/WQCharts)
[![Version](https://img.shields.io/cocoapods/v/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)
[![License](https://img.shields.io/cocoapods/l/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)
[![Platform](https://img.shields.io/cocoapods/p/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)

* WQCharts is a powerful & easy to use chart library for iOS

## Installation
There are four ways to use WQCharts in your project:
### Installation with CocoaPods
```
pod 'WQCharts'
```
### Import 

* Objective-C
```objective-c
#import <WQCharts/WQCharts-Swift.h>
```

* Swift
```swift
import WQCharts
```

## How to use WQCharts

### Using ChartView

* Objective-C
```objective-c
    // Set chart parameters
    chartView.chart.padding = padding;
    chartView.chart.items = items;
    // ...
    [chartView redraw];
```

* Swift
```swift
    // Set Chart parameters
    chartView.chart.padding = padding;
    chartView.chart.items = items;
    // ...
    chartView.redraw()
```

### Using Chart

* Objective-C
```objective-c
    // Set Chart parameters
    chart.padding = padding;
    chart.items = items;
    // Draw Chart in CGContext
    [chart drawRect:rect inContext:context];
```

* Swift
```swift
    // Set Chart parameters
    chart.padding = padding;
    chart.items = items;
    // Draw Chart in CGContext
    chart.draw(rect, context)
```

