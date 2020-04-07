// https://github.com/CoderWQYao/WQCharts-iOS
//
// AxisChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQAxisChartItem)
open class AxisChartItem: ChartItem {

    @objc open var start = CGPoint.zero
    @objc open var end = CGPoint.zero
    @objc open var paint: LinePaint?
    @objc open var headerText: ChartText?
    @objc open var footerText: ChartText?
    
    @objc open var transformStart: TransformCGPoint?
    @objc open var transformEnd: TransformCGPoint?
    
    @objc
    public convenience override init() {
        self.init(.zero,.zero)
    }

    @objc(initWithStart:end:)
    public init(_ start: CGPoint,  _ end: CGPoint) {
        super.init()

        self.start = start
        self.end = end
        self.paint = LinePaint()
    }
    
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        if let transformStart = transformStart {
            start = transformStart.valueForProgress(progress)
        }
        
        if let transformEnd = transformEnd {
            end = transformEnd.valueForProgress(progress)
        }
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        transformStart = nil
        transformEnd = nil
    }
    
}
