// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class RadarChartVC: RadialChartVC<RadarChartView>, ItemsOptionsDelegate, RadarChartDataSource  {
    
    lazy var colors: [UIColor] = {
        return Colors
    }()
    
    override func chartViewDidCreate(_ chartView: RadarChartView) {
        super.chartViewDidCreate(chartView)
        chartView.chart.dataSource = self
    }
    
    override func configChartOptions() {
        super.configChartOptions()
        
        optionsView.addItem(ListCell()
            .setTitle("IndicatorCount")
            .addItem(SliderCell()
                .setSliderValue(0,10,5)
                .setOnValueChange({[weak self](cell, value) in
                    guard let self = self else {
                        return
                    }
                    let chartView = self.chartView
                    chartView.chart.setNeedsReloadIndicators()
                    chartView.redraw()
                })
            )
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("IndicatorsLine")
            .setOptions(["OFF","ON","Dash"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                chartView.chart.setNeedsReloadIndicators()
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("IndicatorsText")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                chartView.chart.setNeedsReloadIndicators()
                chartView.redraw()
            })
        )
        
        
        optionsView.addItem(ListCell()
            .setTitle("SegmentCount")
            .addItem(SliderCell()
                .setSliderValue(0,10,5)
                .setOnValueChange({[weak self](cell, value) in
                    guard let self = self else {
                        return
                    }
                    let chartView = self.chartView
                    chartView.chart.setNeedsReloadSegments()
                    chartView.redraw()
                })
            )
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("SegmentsShape")
            .setOptions(["Polygon","Arc"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                chartView.chart.setNeedsReloadSegments()
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("SegmentsLine")
            .setOptions(["OFF","ON","Dash"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                chartView.chart.setNeedsReloadSegments()
                chartView.redraw()
            })
        )
        
    }
    
    // MARK: - Items
    
    lazy var items: NSMutableArray = {
        let items = NSMutableArray()
        for i in 0..<2 {
            if let item = createItem(atIndex: i) {
                items.add(item)
            }
        }
        return items
    }()
    
    var itemsOptionTitle: String {
        return "Polygons"
    }
    
    func createItem(atIndex index: Int) -> Any? {
        if index >= colors.count {
            return nil
        }
        let color = colors[index]
        let chart = PolygonChart()
        chart.paint?.fill?.color = color.withAlphaComponent(0.5)
        chart.paint?.stroke = nil
        return RadarChartPolygon(chart)
    }
    
    func createItemCell(withItem item: Any, atIndex index: Int)  -> UIView {
        return SectionCell()
            .setObject(item)
            .setTitle(String(format: "Polygon%ld", index))
            .setOnReload({[weak self](cell) in
                guard let self = self else {
                    return
                }
                let polygon = cell.object as! RadarChartPolygon
                polygon.needsReloadItems = true
                self.chartView.redraw()
            })
    }
    
    func itemsDidChange(_ items: NSMutableArray) {
        chartView.chart.setNeedsReloadPolygons()
        chartView.redraw()
    }
    
    // MARK: - RadarChartDataSource
    
    func numberOfIndicatorsInRadarChart(_ radarChart: RadarChart) -> Int {
        return sliderIntegerValue(forKey: "IndicatorCount", atIndex: 0)
    }
    
    func radarChart(_ radarChart: RadarChart, indicatorAtIndex index: Int) -> RadarChartIndicator {
        let indicator = RadarChartIndicator()
        setupStrokePaint(indicator.paint, Color_White, radioCellSelectionForKey("IndicatorsLine"))
        if radioCellSelectionForKey("IndicatorsText") != 0 {
            let text = ChartText()
            text.font = UIFont.systemFont(ofSize: 11)
            text.color = Color_White
            text.textOffsetByAngle = {(text, size, angle) -> CGFloat in
                return 15
            }
            text.string = String(format: "I-%ld", index)
            indicator.text = text
        }
        return indicator
    }
    
    func numberOfSegmentsInRadarChart(_ radarChart: RadarChart) -> Int {
        return sliderIntegerValue(forKey: "SegmentCount", atIndex: 0)
    }
    
    func radarChart(_ radarChart: RadarChart, segmentAtIndex index: Int) -> RadarChartSegment {
        let segment = RadarChartSegment()
        setupStrokePaint(segment.paint, Color_White, radioCellSelectionForKey("SegmentsLine"))
        segment.shape = radioCellSelectionForKey("SegmentsShape") != 0 ? .Arc : .Polygon
        segment.value = 1.0 - 1.0 / CGFloat(numberOfSegmentsInRadarChart(radarChart)) * CGFloat(index)
        return segment
    }
    
    func numberOfPolygonsInRadarChart(_ radarChart: RadarChart) -> Int {
        return items.count
    }
    
    func radarChart(_ radarChart: RadarChart, polygontAtIndex index: Int) -> RadarChartPolygon {
        return items[index] as! RadarChartPolygon
    }
    
    func radarChart(_ radarChart: RadarChart, itemOfChartForPolygonAtIndexPath indexPath: IndexPath) -> PolygonChartItem {
        let item = PolygonChartItem(CGFloat.random(in: 0...1))
        item.axisPaint = nil
        return item
    }
    
    // MARK: - Animation
    
    override func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        super.appendAnimationKeys(animationKeys)
        animationKeys.add("Values")
    }
    
    override func prepareAnimationOfChartView(forKeys keys: [String]) {
        super.prepareAnimationOfChartView(forKeys: keys)
        
        if (keys.contains("Values")) {
            for polygon in items as! [RadarChartPolygon] {
                guard let items = polygon.chart.items else {
                    continue
                }
                for item in items {
                    item.transformValue = TransformCGFloat(item.value, CGFloat.random(in: 0...1))
                }
            }
        }
        
    }
    
    
    
}
