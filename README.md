# WQCharts

[![CI Status](https://img.shields.io/travis/eternalg4@qq.com/WQCharts.svg?style=flat)](https://travis-ci.org/eternalg4@qq.com/WQCharts)
[![Version](https://img.shields.io/cocoapods/v/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)
[![License](https://img.shields.io/cocoapods/l/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)
[![Platform](https://img.shields.io/cocoapods/p/WQCharts.svg?style=flat)](https://cocoapods.org/pods/WQCharts)

* WQCharts is a powerful & easy to use chart library for iOS

## Usage

### Using ChartView

```objective-c
    // Set chart parameters
    chartView.chart.padding = padding;
    chartView.chart.items = items;
    // ...
    [chartView redraw];
```

```swift
    // Set Chart parameters
    chartView.chart.padding = padding;
    chartView.chart.items = items;
    // ...
    chartView.redraw()
```

### Using Chart

```objective-c
    // Set Chart parameters
    chart.padding = padding;
    chart.items = items;
    // Draw Chart in CGContext
    [chart drawRect:rect inContext:context];
```

```swift
    // Set Chart parameters
    chart.padding = padding;
    chart.items = items;
    // Draw Chart in CGContext
    chart.draw(rect, context)
```

