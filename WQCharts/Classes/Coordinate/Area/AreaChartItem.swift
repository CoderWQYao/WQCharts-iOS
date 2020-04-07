// https://github.com/CoderWQYao/WQCharts-iOS
//
// AreaChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQAreaChartItem)
open class AreaChartItem: ChartItem {
    
    @objc open var value = CGPoint.zero
    @objc open var headerText: ChartText?
    @objc open var footerText: ChartText?
    
    @objc open var transformValue: TransformCGPoint?
    
    @objc
    public convenience override init() {
        self.init(.zero)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGPoint) {
        super.init()
        
        self.value = value
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        if let transformValue = transformValue {
            value = transformValue.valueForProgress(progress)
        }
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        transformValue = nil
    }
}
