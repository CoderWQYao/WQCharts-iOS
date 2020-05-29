// https://github.com/CoderWQYao/WQCharts-iOS
//
// BarChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQBarChartItem)
open class BarChartItem: ChartItem {
    
    @objc open var x = CGFloat(0)
    @objc open var endY = CGFloat(0)
    @objc open var startY: NSNumber?
    
    @objc open var barWidth = CGFloat(0)
    @objc open var paint: ChartShapePaint?
    @objc open var cornerRadius1 = CGFloat(0)
    @objc open var cornerRadius2 = CGFloat(0)
    @objc open var cornerRadius3 = CGFloat(0)
    @objc open var cornerRadius4 = CGFloat(0)
    @objc open var headerText: ChartText?
    @objc open var footerText: ChartText?
    
    @objc open var xTween: ChartCGFloatTween?
    @objc open var endYTween: ChartCGFloatTween?
    @objc open var startYTween: ChartCGFloatTween?
    
    @objc
    public convenience override init() {
        self.init(0, 0)
    }
    
    @objc(initWithX:endY:)
    public convenience init(_ x: CGFloat, _ endY: CGFloat) {
        self.init(x, endY, 10)
    }
    
    @objc(initWithX:endY:barWidth:)
    public convenience init(_ x: CGFloat, _ endY: CGFloat, _ barWidth: CGFloat) {
        self.init(x, endY, barWidth, nil)
    }
    
    @objc(initWithX:endY:barWidth:startY:)
    public init(_ x: CGFloat, _ endY: CGFloat, _ barWidth: CGFloat, _ startY: NSNumber?) {
        self.x = x
        self.endY = endY
        self.barWidth = barWidth
        self.startY = startY
        self.paint = ChartShapePaint()
    }
    
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        
        if let xTween = xTween {
            x = xTween.lerp(t)
        }
        
        if let endYTween = endYTween {
            endY = endYTween.lerp(t)
        }
        
        if let startYTween = startYTween {
            startY = startYTween.lerp(t) as NSNumber
        }
        
        paint?.transform(t)
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        
        xTween = nil
        endYTween = nil
        startYTween = nil
        paint?.clearAnimationElements()
    }
    
}
