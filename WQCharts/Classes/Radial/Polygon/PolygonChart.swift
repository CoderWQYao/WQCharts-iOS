// 代码地址: 
// PolygonChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 多边形图表
@objc(WQPolygonChart)
open class PolygonChart: RadialChart {
    
    /// 多边形子项
    @objc open var items: [PolygonChartItem]?
    
    /// 多边形油漆
    @objc open var shapePaint: ShapePaint?
    
    /// 图形轴线油漆
    @objc open var axisPaint: LinePaint?
    
    
    @objc
    public override init() {
        shapePaint = ShapePaint()
        axisPaint = LinePaint()
    }
    
    open override func draw(_ rect: CGRect, _ context: CGContext) {
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
        var shapeRadius = CGFloat(0.0)
        let shapePath = CGMutablePath()
        let axisPath = CGMutablePath()
        
        for i in 0..<itemCount {
            let item = items[i]
            let itemAngle = sweepAngle * CGFloat(i) + startAngle
            let itemPointRadian = Helper.convertAngleToRadian(itemAngle)
            let itemPointRadius = radius * CGFloat(item.value)
            let itemPoint = CGPoint(x: center.x + itemPointRadius * sin(itemPointRadian),y: center.y - itemPointRadius * cos(itemPointRadian))
            
            if i == 0 {
                shapePath.move(to: itemPoint)
            } else {
                shapePath.addLine(to: itemPoint)
            }
            
            axisPath.move(to: center)
            axisPath.addLine(to: itemPoint)
            
            let graphicItem = PolygonGraphicItem(item)
            graphicItem.angle = itemAngle
            graphicItem.point = itemPoint
            graphicItems.add(graphicItem)
            
            shapeRadius = max(shapeRadius, itemPointRadius)
        }
        
        if itemCount > 0 {
            shapePath.closeSubpath()
        }
        
        graphic.shapeRadius = shapeRadius
        graphic.shapePath = shapePath
        graphic.axisPath = axisPath
        graphic.items = (graphicItems as! [PolygonGraphicItem])
        
        if let shapePaint = self.shapePaint {
            shapePaint.draw(shapePath, context, graphic)
        }
        
        if let axisPaint = self.axisPaint {
            axisPaint.draw(axisPath, context)
        }
        
        return graphic
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
}
