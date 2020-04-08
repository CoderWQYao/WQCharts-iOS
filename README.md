# WQCharts

[![Version](https://img.shields.io/cocoapods/v/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)
[![License](https://img.shields.io/cocoapods/l/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)
[![Platform](https://img.shields.io/cocoapods/p/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)

* WQCharts highly customizable and easy to use chart library for iOS

## Installation
There are four ways to use WQCharts in your project:

### Installation with CocoaPods
```
pod 'WQCharts'
```

### Installation with Swift Package Manager (Xcode 11+)

[Swift Package Manager](https://swift.org/package-manager/) (SwiftPM) is a tool for managing the distribution of Swift code as well as C-family dependency. From Xcode 11, SwiftPM got natively integrated with Xcode.

WQCharts support SwiftPM from version 5.1.0. To use SwiftPM, you should use Xcode 11 to open your project. Click `File` -> `Swift Packages` -> `Add Package Dependency`, enter [WQCharts repo's URL](https://github.com/CoderWQYao/WQCharts-iOS.git). Or you can login Xcode with your GitHub account and just type `WQCharts` to search.

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
```objc
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
```objc
    // Set Chart parameters
    chart.padding = padding;
    chart.items = items;
    // Draw Chart in CGContext
    [chart drawInRect:rect context:context];
```

* Swift
```swift
    // Set Chart parameters
    chart.padding = padding;
    chart.items = items;
    // Draw Chart in CGContext
    chart.draw(inRect: rect, context: context)
```
### Using Animation

* Objective-C
```objc
    WQAnimationPlayer* animationPlayer = [[WQAnimationPlayer alloc] initWithDisplayView:self.chartView];
    // The ChartView、Chart conforms to Transformable protocol
    WQAnimation* animation = [[WQAnimation alloc] initWithTransformable:self.chartView duration:0.5];
    [animationPlayer startAnimation:animation];
    self.animationPlayer = animationPlayer;
```

* Swift
```swift
    let animationPlayer = AnimationPlayer(displayView: self.chartView)
    // The ChartView、Chart conforms to Transformable protocol
    let animation = Animation(self.chartView, 0.5)
    animationPlayer.startAnimation(animation)
    self.animationPlayer = animationPlayer
```

## Architecture

### Structure Diagram
![Structure Diagram](http://appdata.cc/WQCharts_StructureDiagram.png)

### Chart Class Diagram
![Chart Class Diagram](http://appdata.cc/WQCharts_ChartDiagram.png)

### View Class Diagram
![View Class Diagram](http://appdata.cc/WQCharts_ViewDiagram.png)

## Examples

![WQCharts_Polygon](http://appdata.cc/WQCharts_Polygon.gif)
![WQCharts_Pie](http://appdata.cc/WQCharts_Pie.gif)
![WQCharts_Pie](http://appdata.cc/WQCharts_Radar.gif)
![WQCharts_Axis](http://appdata.cc/WQCharts_Axis.gif)
![WQCharts_Bar](http://appdata.cc/WQCharts_Bar.gif)
![WQCharts_Biz](http://appdata.cc/WQCharts_Biz.gif)

