// https://github.com/CoderWQYao/WQCharts-iOS
//
// PolygonChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPolygonChartItem)
open class PolygonChartItem: ChartItem {

    @objc open var value = CGFloat(0)
    @objc open var text: ChartText?
    @objc open var axisPaint: LinePaint?
    
    @objc open var transformValue: TransformCGFloat?
    
    @objc
    public override convenience init() {
        self.init(0)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGFloat) {
        self.value = value
        self.axisPaint = LinePaint()
        
        super.init()
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        if let transformValue = transformValue {
            value = transformValue.valueForProgress(progress)
        }
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        transformValue = nil;
    }
}
