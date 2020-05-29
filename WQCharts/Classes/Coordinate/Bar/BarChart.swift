// https://github.com/CoderWQYao/WQCharts-iOS
//
// BarChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQBarChart)
open class BarChart: CoordinateChart {
    
    @objc open var items: [BarChartItem]?
    
    override open func draw(inRect rect: CGRect, context: CGContext) {
        let graphic = drawGraphic(rect, context)
        drawText(graphic, context)
    }
    
    @objc(drawGraphicInRect:context:)
    open func drawGraphic(_ rect: CGRect, _ context: CGContext) -> BarGraphic {
        let graphic = BarGraphic(self, rect)
        
        guard let items = self.items else {
            return graphic
        }
        
        let itemCount = items.count
        let bounds = graphic.bounds
        let exchangeXY = graphic.exchangeXY
        let stringAngle = graphic.stringAngle
        let graphicItems = NSMutableArray(capacity: itemCount)
        
        for i in 0..<itemCount {
            let item = items[i]
            let endY = item.endY
            var angleReversed = false
            let itemStringStart: CGPoint
            if item.startY != nil {  // 起始点
                let startY = CGFloat(item.startY!.doubleValue)
                itemStringStart = graphic.convertBoundsPointToRect(CGPoint(x: item.x, y: startY))
                if endY < startY {
                    angleReversed = true
                }
            } else {
                itemStringStart = graphic.convertBoundsPointToRect(CGPoint(x: item.x, y: bounds.minY))
            }
            let itemStringEnd = graphic.convertBoundsPointToRect(CGPoint(x: item.x, y: endY))
    
            let barWidth = item.barWidth
            let itemRect: CGRect
            if exchangeXY {
                let itemWidth = max(itemStringStart.x, itemStringEnd.x) - min(itemStringStart.x, itemStringEnd.x)
                let itemHeight = barWidth
                let itemX = min(itemStringStart.x,itemStringEnd.x)
                let itemY = itemStringStart.y - itemHeight / 2
                itemRect = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            } else {
                let itemWidth = barWidth
                let itemHeight = max(itemStringStart.y, itemStringEnd.y) - min(itemStringStart.y, itemStringEnd.y)
                let itemX = itemStringStart.x - itemWidth / 2
                let itemY = min(itemStringStart.y,itemStringEnd.y)
                itemRect = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            }
            
            
            var itemStringAngle = stringAngle
            if angleReversed {
                itemStringAngle = Helper.angleIn360Degree(itemStringAngle + 180)
            }
            
            let itemPath = Helper.createRectPath(itemRect, itemStringAngle, item.cornerRadius1, item.cornerRadius2, item.cornerRadius3, item.cornerRadius4)
            
            let graphicItem = BarGraphicItem(item)
            graphicItem.angleReversed = angleReversed
            graphicItem.stringStart = itemStringStart
            graphicItem.stringEnd = itemStringEnd
            graphicItem.stringAngle = itemStringAngle
            graphicItem.rect = itemRect
            graphicItem.path = itemPath
            graphicItems.add(graphicItem)
            if let itemPaint = item.paint {
                itemPaint.draw(itemPath, ChartShaderRect(itemRect, itemRect), context)
            }
        }
        
        graphic.items = (graphicItems as! [BarGraphicItem])
        return graphic
    }
    
    @objc(drawTextForGraphic:inContext:)
    open func drawText(_ graphic: BarGraphic, _ context: CGContext) {
        guard let items = graphic.items else {
            return
        }
        
        for item in items {
            let builder = item.builder as! BarChartItem
            let stringAngle = item.stringAngle
            if let headerText = builder.headerText {
                headerText.draw(item.stringStart, NSNumber(value: Double(Helper.angleIn360Degree(stringAngle + 180))), context)
            }
            if let footerText = builder.footerText {
                footerText.draw(item.stringEnd, NSNumber(value: Double(stringAngle)), context)
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
            let x = item.x
            let endY = item.endY
            if i==0 {
                minX = x
                maxX = x
                if item.startY != nil {
                    let startY = CGFloat(item.startY!.doubleValue)
                    minY = min(startY,endY)
                    maxY = max(startY,endY)
                } else {
                    minY = endY
                    maxY = endY
                }
            } else {
                minX = min(minX, x)
                maxX = max(maxX, x)
                if item.startY != nil {
                    let startY = CGFloat(item.startY!.doubleValue)
                    minY = min(minY,min(startY,endY))
                    maxY = max(maxY,max(startY,endY))
                } else {
                    minY = min(minY,endY)
                    maxY = max(maxY,endY)
                }
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
    
    @objc open func convertRelativePoint(byItem item: BarChartItem,fromViewPoint viewPoint: CGPoint) -> CGPoint {
        if let startY = item.startY, CGFloat(truncating: startY) > item.endY {
            return super.convertRelativePoint(fromViewPoint: CGPoint(x: viewPoint.x, y: 1 - viewPoint.y))
        }
        return super.convertRelativePoint(fromViewPoint: viewPoint)
    }
    
}
