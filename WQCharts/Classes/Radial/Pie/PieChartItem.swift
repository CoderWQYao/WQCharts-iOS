// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPieChartItem)
open class PieChartItem: ChartItem {
    
    @objc open var value = CGFloat(0)
    @objc open var arc1Scale = CGFloat(0)
    @objc open var arc2Scale = CGFloat(0)
    @objc open var driftRatio = CGFloat(0)
    @objc open var paint: ChartShapePaint?
    @objc open var text: ChartText?
    
    @objc open var valueTween: ChartCGFloatTween?
    @objc open var arc1ScaleTween: ChartCGFloatTween?
    @objc open var arc2ScaleTween: ChartCGFloatTween?
    @objc open var driftRatioTween: ChartCGFloatTween?
    
    @objc
    public override convenience init() {
        self.init(0)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGFloat) {
        super.init()
        self.value = value
        self.paint = ChartShapePaint()
        self.arc2Scale = 0
        self.arc1Scale = 1
    }
    
    
    @objc open class func calcTotalValue(withItems items: [PieChartItem]?) -> CGFloat {
        var totalValue = CGFloat(0)
        guard let items = items else {
            return totalValue
        }
        
        for item in items {
            totalValue += item.value
        }
        return totalValue
    }
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        
        if let valueTween = valueTween {
            value = valueTween.lerp(t)
        }
        
        if let arc1ScaleTween = arc1ScaleTween {
            arc1Scale = arc1ScaleTween.lerp(t)
        }
        
        if let arc2ScaleTween = arc2ScaleTween {
            arc2Scale = arc2ScaleTween.lerp(t)
        }
        
        if let driftRatioTween = driftRatioTween {
            driftRatio = driftRatioTween.lerp(t)
        }
        
        paint?.transform(t)
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        
        valueTween = nil
        arc1ScaleTween = nil
        arc2ScaleTween = nil
        driftRatioTween = nil
        paint?.clearAnimationElements()
    }
    
}
