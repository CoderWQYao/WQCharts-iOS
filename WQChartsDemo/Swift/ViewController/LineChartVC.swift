// https://github.com/CoderWQYao/WQCharts-iOS
//
// LineChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class LineChartVC: BarLineChartVC<LineChartView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsView.addItem(RadioCell()
            .setTitle("FixedBounds")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                if selection != 0 {
                    chartView.chart.fixedMinY = 0
                    chartView.chart.fixedMaxY = 99
                } else {
                    chartView.chart.fixedMinY = nil
                    chartView.chart.fixedMaxY = nil
                }
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ShapeFill")
            .setOptions(["OFF","ON","Gradient"])
            .setSelection(2)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                guard let paint = chartView.chart.shapePaint?.fill else {
                    return
                }
                switch (selection) {
                case 1:
                    paint.color = Color_Blue
                    paint.shader = nil
                case 2:
                    paint.color = nil
                    paint.shader = {(paint, path, object) -> Shader? in
                        let graphic = object as! LineGraphic
                        return LinearGradientShader(graphic.stringStart, graphic.stringEnd, [Color_Blue.withAlphaComponent(0.1),Color_Blue], [0,1])
                    }
                default:
                    paint.color = nil
                    paint.shader = nil
                }
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ShapeStoke")
            .setOptions(["OFF","ON","Dash"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                self.setupStrokePaint(chartView.chart.shapePaint?.stroke, Color_White, selection)
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("LinePaint")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                chartView.chart.linePaint?.color = selection != 0 ? Color_Red : .clear
                chartView.redraw()
            })
        )
        
        let itemsCell = ListCell()
            .setTitle("Items")
            .setIsMutable(true)
            .setOnAppend({[weak self](cell) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                let item = self.createItem(chartView.chart.items?.count ?? 0)
                chartView.chart.items?.append(item)
                chartView.redraw()
                
                cell.addItem(self.createCell(item))
                self.scrollToListCell("Items", .Bottom, true)
            }).setOnRemove({[weak self](cell) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                let index = (chartView.chart.items?.count ?? 0) - 1
                if index < 0 {
                    return
                }
                cell.removeItem(at: index)
                self.scrollToListCell("Items", .Bottom, true)
                
                chartView.chart.items?.remove(at: index)
                chartView.redraw()
            })
        let items = NSMutableArray()
        for i in 0..<5 {
            let item = createItem(i)
            items.add(item)
            itemsCell.addItem(createCell(item))
        }
        chartView.chart.items = (items as! [LineChartItem])
        optionsView.addItem(itemsCell)
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsHeaderText")
            .setOptions(["OFF","ON"]).setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                guard let items = chartView.chart.items else {
                    return
                }
                
                for item in items {
                    item.headerText?.hidden = selection == 0
                }
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsFooterText")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                guard let items = chartView.chart.items else {
                    return
                }
                
                for item in items {
                    item.footerText?.hidden = selection == 0
                }
                chartView.redraw()
            })
        )
        
        callRadioCellsSectionChange()
    }
    
    func createItem(_ index: Int) -> LineChartItem {
        let item = LineChartItem(CGPoint(x: CGFloat(index), y: CGFloat(arc4random() % 100)))
        
        let headerText = ChartText()
        headerText.font = UIFont.systemFont(ofSize: 9)
        headerText.color = Color_White
        item.headerText = headerText
        
        let footerText = ChartText()
        footerText.font = UIFont.systemFont(ofSize: 9)
        footerText.color = Color_White
        item.footerText = footerText
        
        updateItem(item)
        return item
    }
    
    func updateItem(_ item: LineChartItem) {
        let exchangeXY = radioCellSelectionForKey("ExchangeXY") != 0
        
        let string = String(format: "%ld", Int(item.value.y))
        
        if let headerText = item.headerText {
            headerText.string = string
            headerText.hidden = radioCellSelectionForKey("ItemsHeaderText") == 0
            headerText.textOffsetByAngle = {(text, size, angle) -> CGFloat in
                if exchangeXY {
                    return 10
                } else {
                    return 10
                }
            }
        }
        
        if let footerText = item.footerText {
            footerText.string = string
            footerText.hidden = radioCellSelectionForKey("ItemsFooterText") == 0
            footerText.textOffsetByAngle = {(text, size, angle) -> CGFloat in
                if exchangeXY {
                    return 10
                } else {
                    return 10
                }
            }
        }
    }
    
    override func updateItems() {
        let chartView = self.chartView
        if let items = chartView.chart.items {
            for item in items {
                updateItem(item)
            }
        }
        chartView.redraw()
    }
    
    func createCell(_ item: LineChartItem) -> SliderCell {
        return SliderCell()
            .setObject(item)
            .setSliderValue(0,99,item.value.y)
            .setDecimalCount(0)
            .setOnValueChange {[weak self](cell, value) in
                guard let self = self, let item = cell.object as? LineChartItem else {
                    return
                }
                
                item.value.y = value
                self.updateItem(item)
                self.chartView.redraw()
        }
    }
    
}
