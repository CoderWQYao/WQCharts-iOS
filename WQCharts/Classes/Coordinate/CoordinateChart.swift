// https://github.com/CoderWQYao/WQCharts-iOS
//
// CoordinateChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQCoordinateChart)
open class CoordinateChart: NSObject, Chart {
    
    @objc open var fixedMinX: NSNumber?
    @objc open var fixedMaxX: NSNumber?
    @objc open var fixedMinY: NSNumber?
    @objc open var fixedMaxY: NSNumber?
    
    @objc open var exchangeXY: Bool = false
    @objc open var reverseX: Bool = false
    @objc open var reverseY: Bool = false
    
    open func draw(_ rect: CGRect, _ context: CGContext) {
        fatalError("draw(CGRect,CGContext) has not been implemented")
    }
    
    @objc
    open func fixBounds(_ bounds: CGRect) -> CGRect {
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
    
    @objc
    open func calculateUnfixedBounds() -> CGRect {
        fatalError("calculateUnfixedBounds() has not been implemented")
    }
    
}
