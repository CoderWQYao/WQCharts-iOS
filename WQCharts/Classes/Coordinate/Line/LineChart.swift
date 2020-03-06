// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
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
    @objc open var shapePaint: ShapePaint?
    @objc open var linePaint: LinePaint?
    
    public override init() {
        shapePaint = ShapePaint()
        linePaint = LinePaint(.clear)
    }
    
    open override func draw(_ rect: CGRect, _ context: CGContext) {
        let graphic = drawGraphic(rect, context)
        drawText(graphic, context)
    }
    
    
    @objc(drawGraphicInRect:context:)
    open func drawGraphic(_ rect: CGRect, _ context: CGContext) -> LineGraphic {
        let graphic = LineGraphic(self, rect)
        
        guard let items = self.items else {
            return graphic
        }
        
        let itemCount = items.count
        let bounds = graphic.bounds
        let graphicItems = NSMutableArray(capacity: itemCount)
        let shapePath = CGMutablePath()
        let linePath = CGMutablePath()
        
        for i in 0..<itemCount {
            let item = items[i]
            let itemShapeStartPoint = graphic.convertBoundsPointToRect(CGPoint(x: item.value.x, y: bounds.minY))
            let itemShapeEndPoint = graphic.convertBoundsPointToRect(item.value)
            if i==0 {
                shapePath.move(to: itemShapeStartPoint)
                shapePath.addLine(to: itemShapeEndPoint)
                linePath.move(to: itemShapeEndPoint)
            } else {
                shapePath.addLine(to: itemShapeEndPoint)
                linePath.addLine(to: itemShapeEndPoint)
            }
            
            let graphicItem = LineGraphicItem(item)
            graphicItem.shapeStartPoint = itemShapeStartPoint
            graphicItem.shapeEndPoint = itemShapeEndPoint
            graphicItem.linePoint = itemShapeEndPoint
            graphicItems.add(graphicItem)
        }
        
        if let lastGraphicItem = graphicItems.lastObject as? LineGraphicItem  {
            shapePath.addLine(to: lastGraphicItem.shapeStartPoint)
            shapePath.closeSubpath()
        }
        
        let shapeBoundingBox = shapePath.boundingBox
        let stringStart: CGPoint
        let stringEnd: CGPoint
        if exchangeXY {
            let midY = shapeBoundingBox.midY
            stringStart = CGPoint(x: shapeBoundingBox.minX, y: midY)
            stringEnd = CGPoint(x: shapeBoundingBox.maxX, y: midY)
        } else {
            let midX = shapeBoundingBox.midX
            stringStart = CGPoint(x: midX, y: shapeBoundingBox.maxY)
            stringEnd = CGPoint(x: midX, y: shapeBoundingBox.minY)
        }
        graphic.stringStart = stringStart
        graphic.stringEnd = stringEnd
        graphic.shapePath = shapePath
        graphic.linePath = linePath
        graphic.items = (graphicItems as! [LineGraphicItem])
        
        if let shapePaint = shapePaint {
            shapePaint.draw(shapePath, context, graphic)
        }
        
        if let linePaint = linePaint {
            linePaint.draw(linePath, context)
        }
        
        return graphic
    }
    
    @objc(drawTextForGraphic:inContext:)
    open func drawText(_ graphic: LineGraphic, _ context: CGContext) {
        guard let items = graphic.items else {
            return
        }
        
        let stringAngle = graphic.stringAngle
        for item in items {
            let builder = item.builder as! LineChartItem
            if let itemHeaderText = builder.headerText {
                itemHeaderText.draw(item.shapeStartPoint, NSNumber(value: Double(Helper.angleIn360Degree(stringAngle + 180))), context)
            }
            if let itemFooterText = builder.footerText {
                itemFooterText.draw(item.shapeEndPoint, NSNumber(value: Double(stringAngle)), context)
            }
        }
    }
    
    override open func calculateUnfixedBounds() -> CGRect {
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
    
}
