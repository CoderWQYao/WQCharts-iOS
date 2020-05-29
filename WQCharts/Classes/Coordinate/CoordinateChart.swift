// https://github.com/CoderWQYao/WQCharts-iOS
//
// CoordinateChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 表示一个具有平面坐标系的图表抽象
@objc(WQCoordinateChart)
open class CoordinateChart: NSObject, Chart, ChartAnimatable {
    
    @objc open var fixedMinX: NSNumber?
    @objc open var fixedMaxX: NSNumber?
    @objc open var fixedMinY: NSNumber?
    @objc open var fixedMaxY: NSNumber?
    
    @objc open var exchangeXY: Bool = false
    @objc open var reverseX: Bool = false
    @objc open var reverseY: Bool = false
    
    open func draw(inRect rect: CGRect, context: CGContext) {
        fatalError("draw(inRect:,context:) has not been implemented")
    }
    
    /// fix bounds value
    @objc open func fixBounds(_ bounds: CGRect) -> CGRect {
        var minX: CGFloat = bounds.minX
        var maxX: CGFloat = bounds.maxX
        var minY: CGFloat = bounds.minY
        var maxY: CGFloat = bounds.maxY
        
        if let fixedMinX = fixedMinX {
            minX = CGFloat(fixedMinX.doubleValue)
        }
        if let fixedMaxX = fixedMaxX {
            maxX = CGFloat(fixedMaxX.doubleValue)
        }
        if let fixedMinY = fixedMinY {
            minY = CGFloat(fixedMinY.doubleValue)
        }
        if let fixedMaxY = fixedMaxY {
            maxY = CGFloat(fixedMaxY.doubleValue)
        }
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    /// calc bounds value over all items
    @objc open func calcBounds() -> CGRect {
        fatalError("calcBounds() has not been implemented")
    }
    
    @objc open func convertRelativePoint(fromViewPoint viewPoint: CGPoint) -> CGPoint {
        var x: CGFloat = viewPoint.x, y: CGFloat = 1 - viewPoint.y
        
        if reverseX {
            x = 1 - x
        }
        
        if reverseY {
            y = 1 - y
        }
        
        if exchangeXY {
            x = x + y
            y = x - y
            x = x - y
            x = 1 - x
        }
        
        return CGPoint(x: x, y: y);
    }
    
    open func transform(_ t: CGFloat) {
        
    }
    
    open func clearAnimationElements() {
        
    }
    
}
