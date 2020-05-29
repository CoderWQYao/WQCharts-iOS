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
    @objc open var axisPaint: ChartLinePaint?
    
    @objc open var valueTween: ChartCGFloatTween?
    
    @objc
    public override convenience init() {
        self.init(0)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGFloat) {
        self.value = value
        self.axisPaint = ChartLinePaint()
        
        super.init()
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
