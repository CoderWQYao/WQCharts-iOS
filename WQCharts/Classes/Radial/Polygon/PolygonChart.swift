// https://github.com/CoderWQYao/WQCharts-iOS
//
// PolygonChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPolygonChart)
open class PolygonChart: RadialChart {
    
    @objc open var items: [PolygonChartItem]?
    @objc open var paint: ShapePaint?
    
    @objc
    public override init() {
        paint = ShapePaint()
    }
    
    override open func draw(inRect rect: CGRect, context: CGContext) {
        let graphic = drawGraphic(rect, context)
        drawText(graphic, context)
    }
    
    @objc(drawGraphicInRect:context:)
    open func drawGraphic(_ rect: CGRect, _ context: CGContext) -> PolygonGraphic {
        let graphic = PolygonGraphic(self, rect)
        
        guard let items = self.items else {
            return graphic
        }
        
        let itemCount = items.count
        let center = graphic.center
        let radius = graphic.radius
        let angle = graphic.angle
        let startAngle = graphic.rotation
        let graphicItems = NSMutableArray(capacity: itemCount)
        var sweepAngle: CGFloat
        if angle < 360 {
            sweepAngle = itemCount > 1 ? angle / CGFloat(itemCount - 1) : 0
        } else {
            sweepAngle = angle / CGFloat(itemCount)
        }
        if graphic.direction == .CounterClockwise {
            sweepAngle = -sweepAngle
        }
        var pathRadius = CGFloat(0.0)
        let path = CGMutablePath()
        
        for i in 0..<itemCount {
            let item = items[i]
            let itemAngle = sweepAngle * CGFloat(i) + startAngle
            let itemPointRadian = Helper.convertAngleToRadian(itemAngle)
            let itemPointRadius = radius * CGFloat(item.value)
            let itemPoint = CGPoint(x: center.x + itemPointRadius * sin(itemPointRadian),y: center.y - itemPointRadius * cos(itemPointRadian))
            
            let itemAxisPath = CGMutablePath()
            itemAxisPath.move(to: center)
            itemAxisPath.addLine(to: itemPoint)
            
            if i == 0 {
                path.move(to: itemPoint)
            } else {
                path.addLine(to: itemPoint)
            }
            
            let graphicItem = PolygonGraphicItem(item)
            graphicItem.angle = itemAngle
            graphicItem.point = itemPoint
            graphicItem.axisPath = itemAxisPath
            graphicItems.add(graphicItem)
            
            pathRadius = max(pathRadius, itemPointRadius)
        }
        
        if itemCount > 0 {
            if angle < 360 {
                path.addLine(to: center)
            }
            path.closeSubpath()
        }
        
        graphic.pathRadius = pathRadius
        graphic.path = path
        graphic.items = (graphicItems as! [PolygonGraphicItem])
        
        if let paint = self.paint {
            paint.draw(path, context, graphic)
        }
        
        for graphicItem in (graphicItems as! [PolygonGraphicItem]) {
            let item = graphicItem.builder as! PolygonChartItem
            guard let axisPaint = item.axisPaint else {
                continue
            }
            axisPaint.draw(graphicItem.axisPath!, context)
        }
        
        return graphic
    }
    
    @objc(drawAxisForGraphic:inContext:)
    open func drawAxis(_ graphic: PolygonGraphic, _ context: CGContext) {
        guard let items = graphic.items else {
            return
        }
        
        for item in items {
            guard let axisPath = item.axisPath else {
                continue
            }
            let builder = item.builder as! PolygonChartItem
            guard let axisPaint = builder.axisPaint else {
                continue
            }
            axisPaint.draw(axisPath, context)
        }
    }
    
    @objc(drawTextForGraphic:inContext:)
    open func drawText(_ graphic: PolygonGraphic, _ context: CGContext) {
        guard let items = graphic.items else {
            return
        }
        
        for item in items {
            let builder = item.builder as! PolygonChartItem
            guard let text = builder.text else {
                continue
            }
            text.draw(item.point, NSNumber(value: Double(item.angle)), context)
        }
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        paint?.nextTransform(progress)
        
        if let items = items {
            for item in items {
                item.nextTransform(progress)
            }
        }
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        paint?.clearTransforms()
        
        if let items = items {
            for item in items {
                item.clearTransforms()
            }
        }
    }
    
}
