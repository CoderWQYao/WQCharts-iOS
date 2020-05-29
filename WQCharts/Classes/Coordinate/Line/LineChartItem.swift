// https://github.com/CoderWQYao/WQCharts-iOS
//
// LineChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQLineChartItem)
open class LineChartItem: ChartItem {
    
    @objc open var value = CGPoint.zero
    @objc open var text: ChartText?
    
    @objc open var valueTween: ChartCGPointTween?
    
    @objc
    public convenience override init() {
        self.init(.zero)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGPoint) {
        super.init()
        
        self.value = value
    }
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        
        if let valueTween = valueTween {
            value = valueTween.lerp(t)
        }
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        
        valueTween = nil
    }
    
}
