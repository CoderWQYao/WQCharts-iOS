// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPieChart)
open class PieChart: RadialChart {
    
    @objc open var items: [PieChartItem]?
    
    override open func draw(inRect rect: CGRect, context: CGContext) {
        let graphic = drawGraphic(rect, context)
        drawText(graphic, context)
    }
    
    @objc(drawGraphicInRect:context:)
    open func drawGraphic(_ rect: CGRect, _ context: CGContext) -> PieGraphic {
        let graphic = PieGraphic(self, rect)
        
        guard let items = self.items else {
            return graphic
        }
        
        let itemCount = items.count
        let center = graphic.center
        let radius = graphic.radius
        let angle = graphic.angle
        let direction = graphic.direction
        var itemStartAngle = graphic.rotation
        let totalValue = PieChartItem.calcTotalValue(withItems: items)
        let graphicItems = NSMutableArray(capacity: items.count)
        
        for i in 0..<itemCount {
            let item = items[i]
            let itemArc1Radius = radius * item.arc1Scale
            let itemArc2Radius = radius * item.arc2Scale
            let offset = radius * item.driftRatio
            let percent = totalValue != 0 ? item.value / totalValue : 1
            var itemSweepAngle = angle * percent
            if direction == .CounterClockwise {
                itemSweepAngle = -itemSweepAngle
            }
            let arcStartRadian = Helper.convertAngleToRadian(itemStartAngle)
            let arcSweepRadian = Helper.convertAngleToRadian(itemSweepAngle)
            let itemCenter = CGPoint(x: center.x + offset * cos(arcStartRadian + arcSweepRadian / 2.0), y: center.y + offset * sin(arcStartRadian + arcSweepRadian / 2.0))
            
            let itemPath = CGMutablePath()
            itemPath.move(to: CGPoint(x: itemCenter.x + itemArc2Radius * cos(arcStartRadian), y: itemCenter.y + itemArc2Radius * sin(arcStartRadian)))
            itemPath.addRelativeArc(center: itemCenter, radius: itemArc1Radius, startAngle: arcStartRadian, delta: arcSweepRadian)
            itemPath.addRelativeArc(center: itemCenter, radius: itemArc2Radius, startAngle: arcStartRadian + arcSweepRadian, delta: -arcSweepRadian)
            itemPath.closeSubpath()
            
            
            let graphicItem = PieGraphicItem(item)
            graphicItem.center = itemCenter
            graphicItem.arc1Radius = itemArc1Radius
            graphicItem.arc2Radius = itemArc2Radius
            graphicItem.startAngle = itemStartAngle
            graphicItem.sweepAngle = itemSweepAngle
            graphicItem.path = itemPath
            graphicItems.add(graphicItem)
            
            if let itemPaint = item.paint {
                itemPaint.draw(
                    itemPath,
                    ChartShaderRect(
                        Helper.rectFrom(center: center, radius: radius),
                        Helper.rectFrom(center: center, radius: radius)
                    ),
                    context
                )
            }
            
            itemStartAngle += itemSweepAngle
        }
        
        graphic.totalValue = totalValue
        graphic.items = (graphicItems as! [PieGraphicItem])
        return graphic
    }
    
    @objc(drawTextForGraphic:inContext:)
    open func drawText(_ graphic: PieGraphic, _ context: CGContext) {
        guard let items = graphic.items else {
            return
        }
        
        for item in items {
            let builder = item.builder as! PieChartItem
            guard let text = builder.text else {
                continue
            }
            // +90修正角度，PieChart与其他Chart起始位置不一样，PieChart以3点钟方向为0度
            let textAngle = item.startAngle + item.sweepAngle / 2.0 + 90
            let textRadian = Helper.convertAngleToRadian(textAngle)
            let textOffset = (item.arc2Radius + item.arc1Radius) / 2.0
            let textPoint = CGPoint(x: item.center.x + textOffset * sin(textRadian), y: item.center.y - textOffset * cos(textRadian))
            text.draw(textPoint, NSNumber(value: Double(textAngle)), context)
        }
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
