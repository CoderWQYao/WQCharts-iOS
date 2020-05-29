// https://github.com/CoderWQYao/WQCharts-iOS
//
// AxisChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQAxisChart)
open class AxisChart: CoordinateChart {
    
    @objc open var items: [AxisChartItem]?
    
    override open func draw(inRect rect: CGRect, context: CGContext) {
        let graphic = drawGraphic(rect, context)
        drawText(graphic, context)
    }
    
    @objc(drawGraphicInRect:context:)
    open func drawGraphic(_ rect: CGRect, _ context: CGContext) -> AxisGraphic {
        let graphic = AxisGraphic(self, rect)
        
        guard let items = self.items else {
            return graphic
        }
        
        let itemCount = items.count
        let graphicItems = NSMutableArray(capacity: itemCount)
        
        for i in 0..<itemCount {
            let item = items[i]
            let itemStartPoint = graphic.convertBoundsPointToRect(item.start)
            let itemEndPoint = graphic.convertBoundsPointToRect(item.end)
            
            let itemPath = CGMutablePath()
            itemPath.move(to: itemStartPoint)
            itemPath.addLine(to: itemEndPoint)
            
            let graphicItem = AxisGraphicItem(item)
            graphicItem.startPoint = itemStartPoint
            graphicItem.endPoint = itemEndPoint
            graphicItem.path = itemPath
            graphicItems.add(graphicItem)
            
            if let itemPaint = item.paint {
                itemPaint.draw(itemPath, context)
            }
            
        }
        
        graphic.items = (graphicItems as! [AxisGraphicItem])
        return graphic
    }
    
    @objc(drawTextForGraphic:inContext:)
    open func drawText(_ graphic: AxisGraphic, _ context: CGContext) {
        guard let items = graphic.items else {
            return
        }
        
        for item in items {
            let builder = item.builder as! AxisChartItem
            let startPoint = item.startPoint
            let endPoint = item.endPoint
            if let headerText = builder.headerText {
                let radian = atan2((startPoint.x - endPoint.x), (endPoint.y - startPoint.y))
                let angle = Helper.convertRadianToAngle(radian)
                headerText.draw(startPoint, NSNumber(value: Double(angle)), context)
            }
            if let footerText = builder.footerText {
                let radian = atan2((endPoint.x - startPoint.x), (startPoint.y - endPoint.y))
                let angle = Helper.convertRadianToAngle(radian)
                footerText.draw(endPoint, NSNumber(value: Double(angle)), context)
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
            let start = item.start
            let end = item.end
            if i==0 {
                minX = min(start.x,end.x)
                maxX = max(start.x,end.x)
                minY = min(start.y,end.y)
                maxY = max(start.y,end.y)
            } else {
                minX = min(minX, min(start.x,end.x))
                maxX = max(maxX, max(start.x,end.x))
                minY = min(minX, min(start.y,end.y))
                maxY = max(maxY, max(start.y,end.y))
            }
        }
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        
        if let items = items {
           for item in items {
               item.transform(t)
           }
        }
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        
        if let items = items {
            for item in items {
                item.clearAnimationElements()
            }
        }
    }
    
}
