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
    @objc open var paint: LinePaint?
    
    @objc open var transformValue: TransformCGFloat?
    
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
        self.paint = LinePaint()
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        if let transformValue = transformValue {
            value = transformValue.valueForProgress(progress)
        }
        paint?.nextTransform(progress)
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        transformValue = nil
        paint?.clearTransforms()
    }
    
}
