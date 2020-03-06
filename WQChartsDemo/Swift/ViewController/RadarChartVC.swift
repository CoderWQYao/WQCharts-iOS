// 代码地址: 
// RadarChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class RadarChartVC: RadialChartVC<RadarChartView>, RadarChartDataSource {

    lazy var polygons: NSMutableArray = {
        return NSMutableArray()
    }()
    
    lazy var colors: [UIColor] = {
        return Colors
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.chart.dataSource = self
        
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
        
        let polygonsCell = ListCell()
            .setTitle("Polygons")
            .setIsMutable(true)
            .setOnAppend({[weak self](cell) in
                guard let self = self else {
                    return
                }
                let index = self.polygons.count
                if index >= self.colors.count {
                    return
                }
                
                let chartView = self.chartView
                
                let item = self.createPolygon(index)
                self.polygons.add(item)
                chartView.chart.setNeedsReloadPolygons()
                chartView.redraw()
                
                cell.addItem(self.createPolygonCell(item,index))
                self.scrollToListCell("Polygons", .Bottom, true)
            }).setOnRemove({[weak self](cell) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                let index = self.polygons.count - 1
                if index < 0 {
                    return
                }
                cell.removeItem(at: index)
                self.scrollToListCell("Polygons", .Bottom, true)
                
                self.polygons.removeObject(at: index)
                chartView.chart.setNeedsReloadPolygons()
                chartView.redraw()
            })
        let polygons = self.polygons
        for i in 0..<2 {
            let polygon = createPolygon(i)
            polygons.add(polygon)
            polygonsCell.addItem(createPolygonCell(polygon,i))
        }
        optionsView.addItem(polygonsCell)
        
        callRadioCellsSectionChange()
    }
    
    func createPolygon(_ index: Int) -> RadarChartPolygon {
        let color = index < colors.count ? colors[index] : .clear
        let chart = PolygonChart()
        chart.shapePaint?.fill?.color = color.withAlphaComponent(0.5)
        chart.shapePaint?.stroke = nil
        chart.axisPaint = nil
        return RadarChartPolygon(chart)
    }
    
    func createPolygonCell(_ polygon: RadarChartPolygon, _ index: Int) -> SectionCell {
        return SectionCell()
            .setObject(polygon)
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
    
    // MARK: - RadarChartAdapter
    
    func getIndicatorCount(_ radarChart: RadarChart) -> Int {
        return getSliderIntegerValue("IndicatorCount", 0)
    }
    
    func getIndicator(_ radarChart: RadarChart, _ index: Int) -> RadarChartIndicator {
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
    
    func getSegmentCount(_ radarChart: RadarChart) -> Int {
        return getSliderIntegerValue("SegmentCount", 0)
    }
    
    func getSegment(_ radarChart: RadarChart, _ index: Int) -> RadarChartSegment {
        let segment = RadarChartSegment()
        setupStrokePaint(segment.paint, Color_White, radioCellSelectionForKey("SegmentsLine"))
        segment.shape = radioCellSelectionForKey("SegmentsShape") != 0 ? .Arc : .Polygon
        segment.value = 1.0 - 1.0 / CGFloat(getSegmentCount(radarChart)) * CGFloat(index)
        return segment
    }
    
    func getPolygonCount(_ radarChart: RadarChart) -> Int {
        return polygons.count
    }
    
    func getPolygon(_ radarChart: RadarChart, _ index: Int) -> RadarChartPolygon {
        return polygons[index] as! RadarChartPolygon
    }
    
    func getPolygonChartItem(_ radarChart: RadarChart, _ indexPath: IndexPath) -> PolygonChartItem {
        return PolygonChartItem(CGFloat(arc4random() % 101) / 100)
    }
    
}
