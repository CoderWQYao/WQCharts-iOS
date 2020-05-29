// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarChartSegment.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadarChartSegment)
open class RadarChartSegment: ChartItem {
    
    @objc(WQRadarChartSegmentShape)
    public enum Shape: Int {
        case Polygon, Arc
    }
    
    @objc open var value = CGFloat(0)
    @objc open var shape: Shape = .Polygon
    @objc open var paint: ChartLinePaint?
    
    @objc open var valueTween: ChartCGFloatTween?
    
    @objc
    public convenience override init() {
        self.init(0)
    }
    
    @objc(initWithValue:)
    public convenience init(_ value: CGFloat) {
        self.init(value, .Polygon)
    }
    
    @objc(initWithValue:shape:)
    public init(_ value: CGFloat, _ shape: Shape) {
        self.value = value
        self.shape = shape
        self.paint = ChartLinePaint()
    }
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        
        if let valueTween = valueTween {
            value = valueTween.lerp(t)
        }
        paint?.transform(t)
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        
        valueTween = nil
        paint?.clearAnimationElements()
    }
    
}
