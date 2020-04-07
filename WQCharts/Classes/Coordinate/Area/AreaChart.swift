// https://github.com/CoderWQYao/WQCharts-iOS
//
// AreaChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQAreaChart)
open class AreaChart: CoordinateChart {
    
    @objc open var items: [AreaChartItem]?
    @objc open var paint: ShapePaint?
    
    public override init() {
        paint = ShapePaint()
        super.init()
    }
    
    override open func draw(inRect rect: CGRect, context: CGContext) {
        let graphic = drawGraphic(rect, context)
        AreaChart.drawText(graphic, context)
    }
    
    
    @objc(drawGraphicInRect:context:)
    open func drawGraphic(_ rect: CGRect, _ context: CGContext) -> AreaGraphic {
        let graphic = AreaGraphic(self, rect)
        
        guard let items = self.items else {
            return graphic
        }
        
        let itemCount = items.count
        let bounds = graphic.bounds
        let graphicItems = NSMutableArray(capacity: itemCount)
        let path = CGMutablePath()
        
        for i in 0..<itemCount {
            let item = items[i]
            let itemStartPoint = graphic.convertBoundsPointToRect(CGPoint(x: item.value.x, y: bounds.minY))
            let itemEndPoint = graphic.convertBoundsPointToRect(item.value)
            if i==0 {
                path.move(to: itemStartPoint)
                path.addLine(to: itemEndPoint)
            } else {
                path.addLine(to: itemEndPoint)
            }
            
            let graphicItem = AreaGraphicItem(item)
            graphicItem.startPoint = itemStartPoint
            graphicItem.endPoint = itemEndPoint
            graphicItems.add(graphicItem)
        }
        
        if let lastGraphicItem = graphicItems.lastObject as? AreaGraphicItem  {
            path.addLine(to: lastGraphicItem.startPoint)
            path.closeSubpath()
        }
        
        let boundingBox = path.boundingBox
        let stringStart: CGPoint
        let stringEnd: CGPoint
        if exchangeXY {
            let midY = boundingBox.midY
            stringStart = CGPoint(x: boundingBox.minX, y: midY)
            stringEnd = CGPoint(x: boundingBox.maxX, y: midY)
        } else {
            let midX = boundingBox.midX
            stringStart = CGPoint(x: midX, y: boundingBox.maxY)
            stringEnd = CGPoint(x: midX, y: boundingBox.minY)
        }
        graphic.stringStart = stringStart
        graphic.stringEnd = stringEnd
        graphic.path = path
        graphic.items = (graphicItems as! [AreaGraphicItem])
        
        if let paint = paint {
            paint.draw(path, context, graphic)
        }
        
        return graphic
    }
    
    @objc(drawTextForGraphic:inContext:)
    open class func drawText(_ graphic: AreaGraphic, _ context: CGContext) {
        guard let items = graphic.items else {
            return
        }
        
        let stringAngle = graphic.stringAngle
        for item in items {
            let builder = item.builder as! AreaChartItem
            if let headerText = builder.headerText {
                headerText.draw(item.startPoint, NSNumber(value: Double(Helper.angleIn360Degree(stringAngle + 180))), context)
            }
            if let footerText = builder.footerText {
                footerText.draw(item.endPoint, NSNumber(value: Double(stringAngle)), context)
            }
        }
    }
    
    override open func calcBounds() -> CGRect {
        guard let items = items else {
            return .zero
        }
        
        var minX = CGFloat(0)
        var maxX = CGFloat(0)
        var minY = CGFloat(0)
        var maxY = CGFloat(0)
        
        let itemCount = items.count
        for i in 0..<itemCount {
            let item = items[i]
            let value = item.value
            if i==0 {
                minX = value.x
                maxX = value.x
                minY = value.y
                maxY = value.y
            } else {
                minX = min(minX, value.x)
                maxX = max(maxX, value.x)
                minY = min(minY, value.y)
                maxY = max(maxY, value.y)
            }
        }
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        if let items = items {
            for item in items {
                item.nextTransform(progress)
            }
        }
        
        paint?.nextTransform(progress)
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        if let items = items {
            for item in items {
                item.clearTransforms()
            }
        }
        paint?.clearTransforms()
    }
    
}
