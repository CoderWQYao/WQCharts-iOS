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
    @objc open var paint: ChartLinePaint?
    @objc open var headerText: ChartText?
    @objc open var footerText: ChartText?
    
    @objc open var startTween: ChartCGPointTween?
    @objc open var endTween: ChartCGPointTween?
    
    @objc
    public convenience override init() {
        self.init(.zero,.zero)
    }

    @objc(initWithStart:end:)
    public init(_ start: CGPoint,  _ end: CGPoint) {
        super.init()

        self.start = start
        self.end = end
        self.paint = ChartLinePaint()
    }
    
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        
        if let startTween = startTween {
            start = startTween.lerp(t)
        }
        
        if let endTween = endTween {
            end = endTween.lerp(t)
        }
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        
        startTween = nil
        endTween = nil
    }
    
}
