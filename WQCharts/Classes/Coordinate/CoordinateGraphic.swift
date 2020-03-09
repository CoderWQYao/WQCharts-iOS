// https://github.com/CoderWQYao/WQCharts-iOS
//
// CoordinateGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQCoordinateGraphic)
open class CoordinateGraphic: Graphic {
    
    @objc open var bounds = CGRect.zero
    @objc open var exchangeXY = false
    @objc open var reverseX = false
    @objc open var reverseY = false

    @objc public var stringAngle: CGFloat {
        get {
            var stringAngle = exchangeXY ? CGFloat(90) : CGFloat(0)
            if reverseY {
                stringAngle += 180
            }
            return stringAngle
        }
    }
    
    public override init(_ builder: Chart, _ rect: CGRect) {
        super.init(builder,rect)
        let chart = builder as! CoordinateChart
        self.bounds = chart.fixBounds(chart.calculateUnfixedBounds())
        self.exchangeXY = chart.exchangeXY
        self.reverseX = chart.reverseX
        self.reverseY = chart.reverseY
    }
    
    @objc public func boundsRatioForX(_ x: CGFloat) -> CGFloat {
        let bounds = self.bounds
        var ratio = CGFloat(0)
        let range = bounds.maxX - bounds.minX
        if range != 0 {
            ratio = (x - bounds.minX) / range
        }
        return ratio
    }
    
    @objc public func boundsRatioForY(_ y: CGFloat) -> CGFloat {
        let bounds = self.bounds
        var ratio = CGFloat(0)
        let range = bounds.maxY - bounds.minY
        if range != 0 {
            ratio = (y - bounds.minY) / range
        }
        return ratio
    }
    
    
    @objc public func rectRatioForX(_ x: CGFloat) -> CGFloat {
        let rect = self.rect
        var ratio = CGFloat(0)
        let range = rect.maxX - rect.minX
        if range != 0 {
            ratio = (x - rect.minX) / range
        }
        return ratio
    }
    
    @objc public func rectRatioForY(_ y: CGFloat) -> CGFloat {
        let rect = self.rect
        var ratio = CGFloat(0)
        let range = rect.maxY - rect.minY
        if range != 0 {
            ratio = (y - rect.minY) / range
        }
        return ratio
    }

    @objc open func convertBoundsPointToRect(_ point: CGPoint) -> CGPoint {
        let ratioX = self.boundsRatioForX(point.x)
        let ratioY = self.boundsRatioForY(point.y)

        let rect = self.rect
        let rectX = rect.minX
        let rectY = rect.minY
        let rectWidth = rect.width
        let rectHeight = rect.height

        var resultX: CGFloat
        var resultY: CGFloat
        if exchangeXY {
            resultY = rectHeight * ratioX
            if reverseX {
                resultY = rectHeight - resultY
            }
            resultX = rectWidth * ratioY
            if reverseY {
                resultX = rectWidth - resultX
            }
        } else {
            resultX = rectWidth * ratioX
            if reverseX {
                resultX = rectWidth - resultX
            }
            resultY = rectHeight - rectHeight * ratioY
            if reverseY {
                resultY = rectHeight - resultY
            }
        }
       
        resultX += rectX
        resultY += rectY
        return CGPoint(x: resultX, y: resultY)
    }
    
    @objc open func convertRectPointToBounds(_ point: CGPoint) -> CGPoint {
        let bounds = self.bounds
        let boundsX = bounds.minX
        let boundsY = bounds.minY
        let boundsWidth = bounds.width
        let boundsHeight = bounds.height
        
        let ratioX = self.rectRatioForX(point.x)
        let ratioY = self.rectRatioForY(point.y)
        
        var resultX: CGFloat
        var resultY: CGFloat
        if exchangeXY {
            resultY = boundsHeight * ratioX
            if reverseX {
                resultY = boundsHeight - resultY
            }
            resultX = boundsWidth * ratioY
            if reverseY {
                resultX = boundsWidth - resultX
            }
        } else {
            resultX = boundsWidth * ratioX
            if reverseX {
                resultX = boundsWidth - resultX
            }
            resultY = boundsHeight - boundsHeight * ratioY
            if reverseY {
                resultY = boundsHeight - resultY
            }
        }
       
        resultX += boundsX
        resultY += boundsY
        return CGPoint(x: resultX, y: resultY)
    }
    
}
