// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadarChartDataSource)
public protocol RadarChartDataSource {
    
    @objc func numberOfIndicatorsInRadarChart(_ radarChart: RadarChart) -> Int
    
    @objc func radarChart(_ radarChart: RadarChart, indicatorAtIndex index: Int) -> RadarChartIndicator
    
    @objc func numberOfSegmentsInRadarChart(_ radarChart: RadarChart) -> Int
    
    @objc func radarChart(_ radarChart: RadarChart, segmentAtIndex index: Int) -> RadarChartSegment
    
    @objc func numberOfPolygonsInRadarChart(_ radarChart: RadarChart) -> Int
    
    @objc func radarChart(_ radarChart: RadarChart, polygontAtIndex index: Int) -> RadarChartPolygon
    
    @objc func radarChart(_ radarChart: RadarChart, itemOfChartForPolygonAtIndexPath indexPath: IndexPath) -> PolygonChartItem
    
}

@objc(WQRadarChart)
open class RadarChart: RadialChart {
    
    public struct Flags: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        static let reloadIndicators = Flags(rawValue: 1 << 0)
        static let reloadSegments = Flags(rawValue: 1 << 1)
        static let reloadPolygons = Flags(rawValue: 1 << 2)
        
        static let all: Flags = [.reloadIndicators, .reloadSegments, .reloadPolygons]
    }
    
    @objc weak open var dataSource: RadarChartDataSource? {
        didSet {
            flags = .all
        }
    }
    
    @objc private(set) public var indicators: [RadarChartIndicator]?
    @objc private(set) public var segments: [RadarChartSegment]?
    @objc private(set) public var polygons: [RadarChartPolygon]?
    
    private var flags: Flags = .all
    
    override open func draw(inRect rect: CGRect, context: CGContext) {
        let graphic = drawGraphic(rect, context)
        drawText(graphic, context)
    }
    
    @objc(drawGraphicInRect:context:)
    open func drawGraphic(_ rect: CGRect, _ context: CGContext) -> RadarGraphic {
        let graphic = RadarGraphic(self, rect)
        
        if flags.contains(.reloadIndicators) {
            let oldIndicatorCount = indicators?.count ?? 0
            reloadIndicators()
            if oldIndicatorCount != indicators?.count ?? 0, let polygons = polygons {
                for polygon in polygons {
                    polygon.needsReloadItems = true
                }
            }
            flags.remove(.reloadIndicators)
        }
        
        if flags.contains(.reloadSegments) {
            reloadSegments()
            flags.remove(.reloadSegments)
        }
        
        if flags.contains(.reloadPolygons) {
            reloadPolygons()
            flags.remove(.reloadPolygons)
        }
        
        reloadPolygonItems()
        
        guard let indicators = indicators else {
            return graphic
        }
        
        let indicatorCount = indicators.count
        let center = graphic.center
        let radius = graphic.radius
        let angle = graphic.angle
        let direction = graphic.direction
        let startAngle = graphic.rotation
        var sweepAngle: CGFloat
        if angle < 360 {
            sweepAngle = indicatorCount > 1 ? angle / CGFloat(indicatorCount - 1) : 0
        } else {
            sweepAngle = angle / CGFloat(indicatorCount)
        }
        if direction == .CounterClockwise {
            sweepAngle = -sweepAngle
        }
        let graphicSegments = NSMutableArray()
        
        if let segments = segments {
            let segmentCount = segments.count
            
            for i in 0..<segmentCount {
                let segment = segments[i]
                let segmentRadius = segment.value * radius
                let segmentPath = CGMutablePath()
                
                for j in 0..<indicatorCount {
                    let segmentRadian = ChartMath.deg2rad(sweepAngle * CGFloat(j) + startAngle)
                    switch segment.shape {
                    case .Polygon:
                        let segmentPoint = CGPoint(x: center.x + segmentRadius * sin(segmentRadian), y: center.y - segmentRadius * cos(segmentRadian))
                        if j == 0 {
                            segmentPath.move(to: segmentPoint)
                        } else {
                            segmentPath.addLine(to: segmentPoint)
                        }
                    case .Arc:
                        segmentPath.move(to: center)
                        if angle < 360 {
                            var segmentSweepAngle = angle
                            if(direction == .CounterClockwise) {
                                segmentSweepAngle = -segmentSweepAngle
                            }
                            let segmentStartRadian = ChartMath.deg2rad(rotation + 90)
                            let segmentSweepRadian = ChartMath.deg2rad(segmentSweepAngle)
                            segmentPath.addRelativeArc(center: center, radius: segmentRadius, startAngle: segmentStartRadian, delta: -segmentSweepRadian)
                        } else {
                            segmentPath.addEllipse(in: CGRect(x: center.x - segmentRadius, y: center.y - segmentRadius, width: segmentRadius * 2, height: segmentRadius * 2))
                        }
                        
                    }
                }
                
                if indicatorCount > 0 {
                    if segment.shape == .Polygon && angle < 360 {
                        segmentPath.addLine(to: center)
                    }
                    segmentPath.closeSubpath()
                }
                
                if let segmentPaint = segment.paint {
                    segmentPaint.draw(segmentPath, context)
                }
                
                let graphicSegment = RadarSegmentGraphic(segment)
                graphicSegment.radius = segmentRadius
                graphicSegment.path = segmentPath
                graphicSegments.add(graphicSegment)
            }
        }
        
        let graphicIndicators = NSMutableArray(capacity: indicatorCount)
        for i in 0..<indicatorCount {
            let indicator = indicators[i]
            let indicatorAngle = sweepAngle * CGFloat(i) + startAngle
            let indicatorRadian = ChartMath.deg2rad(indicatorAngle)
            let indicatorEndPoint = CGPoint(x: center.x + radius * sin(indicatorRadian), y: center.y - radius * cos(indicatorRadian))
            
            let indicatorPath = CGMutablePath()
            indicatorPath.move(to: center)
            indicatorPath.addLine(to: indicatorEndPoint)
            
            if let paint = indicator.paint {
                paint.draw(indicatorPath, context)
            }
            
            let graphicIndicator = RadarIndicatorGraphic(indicator)
            graphicIndicator.angle = indicatorAngle
            graphicIndicator.startPoint = center
            graphicIndicator.endPoint = indicatorEndPoint
            graphicIndicator.path = indicatorPath
            graphicIndicators.add(graphicIndicator)
        }
        
        let graphicPolygons = NSMutableArray()
        if let polygons = polygons {
            for polygon in polygons {
                let polygonChart = polygon.chart
                polygonChart.angle = angle
                polygonChart.direction = direction
                polygonChart.rotation = rotation
                graphicPolygons.add(polygonChart.drawGraphic(rect, context))
            }
        }
        
        graphic.indicators = (graphicIndicators as! [RadarIndicatorGraphic])
        graphic.segments = (graphicSegments as! [RadarSegmentGraphic])
        graphic.polygons = (graphicPolygons as! [PolygonGraphic])
        return graphic
    }
    
    @objc(drawTextForGraphic:inContext:)
    open func drawText(_ graphic: RadarGraphic, _ context: CGContext) {
        if let indicators = graphic.indicators {
            for indicator in indicators {
                let builder = indicator.builder as! RadarChartIndicator
                guard let indicatorText = builder.text else {
                    continue
                }
                indicatorText.draw(indicator.endPoint, NSNumber(value: Double(indicator.angle)), context)
            }
        }
        
        if let polygons = graphic.polygons {
            for polygon in polygons {
                let builder = polygon.builder as! PolygonChart
                builder.drawText(polygon, context)
            }
        }
    }
    
    @objc open func setNeedsReloadIndicators() {
        flags.insert(.reloadIndicators)
    }
    
    @objc open func setNeedsReloadSegments() {
        flags.insert(.reloadSegments)
    }
    
    @objc open func setNeedsReloadPolygons() {
        flags.insert(.reloadPolygons)
    }
    
    func reloadIndicators() {
        let indicators = NSMutableArray()
        if let dataSource = dataSource {
            let count = dataSource.numberOfIndicatorsInRadarChart(self)
            for i in 0..<count {
                let indicator = dataSource.radarChart(self, indicatorAtIndex: i)
                indicators.add(indicator)
            }
        }
        self.indicators = (indicators as! [RadarChartIndicator])
    }
    
    func reloadSegments() {
        let segments = NSMutableArray()
        if let dataSource = dataSource {
            let count = dataSource.numberOfSegmentsInRadarChart(self)
            for i in 0..<count {
                let segment = dataSource.radarChart(self, segmentAtIndex: i)
                segments.add(segment)
            }
        }
        self.segments = (segments as! [RadarChartSegment])
    }
    
    func reloadPolygons() {
        let polygons = NSMutableArray()
        if let dataSource = dataSource {
            let count = dataSource.numberOfPolygonsInRadarChart(self)
            for i in 0..<count {
                let polygon = dataSource.radarChart(self, polygontAtIndex: i)
                polygons.add(polygon)
            }
        }
        self.polygons = (polygons as! [RadarChartPolygon])
    }
    
    func reloadPolygonItems() {
        guard let polygons = polygons else {
            return
        }
        
        for i in 0..<polygons.count {
            let polygon = polygons[i]
            if !polygon.needsReloadItems {
                continue
            }
            let chart = polygon.chart
            var items = [PolygonChartItem]()
            if let dataSource = dataSource, let indicators = indicators {
                for j in 0..<indicators.count {
                    let item = dataSource.radarChart(self, itemOfChartForPolygonAtIndexPath: IndexPath(row: j, section: i))
                    items.append(item)
                }
            }
            chart.items = items
            polygon.needsReloadItems = false
        }
    }
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        
        if let indicators = indicators {
            for indicator in indicators {
                indicator.transform(t)
            }
        }
        
        if let segments = segments {
            for segment in segments {
                segment.transform(t)
            }
        }
        
        if let polygons = polygons {
            for polygon in polygons {
                polygon.transform(t)
            }
        }
        
    }
    
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        
        if let indicators = indicators {
            for indicator in indicators {
                indicator.clearAnimationElements()
            }
        }
        
        if let segments = segments {
            for segment in segments {
                segment.clearAnimationElements()
            }
        }
        
        if let polygons = polygons {
            for polygon in polygons {
                polygon.clearAnimationElements()
            }
        }
        
    }
}
