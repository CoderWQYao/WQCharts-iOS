// https://github.com/CoderWQYao/WQCharts-iOS
//
// LineChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQLineChart)
open class LineChart: CoordinateChart {
    
    @objc open var items: [LineChartItem]?
    @objc open var paint: LinePaint?
    
    public override init() {
        paint = LinePaint(.clear)
        super.init()
    }
    
    override open func draw(inRect rect: CGRect, context: CGContext) {
        let graphic = drawGraphic(rect, context)
        LineChart.drawText(graphic, context)
    }
    
    @objc(drawGraphicInRect:context:)
    open func drawGraphic(_ rect: CGRect, _ context: CGContext) -> LineGraphic {
        let graphic = LineGraphic(self, rect)
        
        guard let items = self.items else {
            return graphic
        }
        
        let itemCount = items.count
        let graphicItems = NSMutableArray(capacity: itemCount)
        let path = CGMutablePath()
        
        for i in 0..<itemCount {
            let item = items[i]
            let itemPoint = graphic.convertBoundsPointToRect(item.value)
            if i==0 {
                path.move(to: itemPoint)
            } else {
                path.addLine(to: itemPoint)
            }
            
            let graphicItem = LineGraphicItem(item)
            graphicItem.point = itemPoint
            graphicItems.add(graphicItem)
        }
        
        graphic.path = path
        graphic.items = (graphicItems as! [LineGraphicItem])
        
        if let paint = paint {
            paint.draw(path, context)
        }
        
        return graphic
    }
    
    @objc(drawTextForGraphic:inContext:)
    open class func drawText(_ graphic: LineGraphic, _ context: CGContext) {
        guard let items = graphic.items else {
            return
        }
        
        let stringAngle = graphic.stringAngle
        for item in items {
            let builder = item.builder as! LineChartItem
            if let text = builder.text {
                text.draw(item.point, NSNumber(value: Double(stringAngle)), context)
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
