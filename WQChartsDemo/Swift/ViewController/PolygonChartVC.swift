// 代码地址: 
// PolygonChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class PolygonChartVC: RadialChartVC<PolygonChartView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.chart.shapePaint?.stroke?.color = Color_White
        
        optionsView.addItem(RadioCell()
            .setTitle("Fill")
            .setOptions(["OFF","ON","Gradient"])
            .setSelection(1)
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
                        let graphic = object as! PolygonGraphic
                        return RadialGradientShader(graphic.center,graphic.shapeRadius,[Color_Blue.withAlphaComponent(0.1),Color_Blue],[0,1])
                    }
                default:
                    paint.color = nil
                    paint.shader = nil
                }
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("Stoke")
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
            .setTitle("Axis")
            .setOptions(["OFF","ON","Dash"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                self.setupStrokePaint(chartView.chart.axisPaint, Color_White, selection)
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
                
                let item = self.createItem()
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
        for _ in 0..<4 {
            let item = createItem()
            items.add(item)
            itemsCell.addItem(createCell(item))
        }
        chartView.chart.items = (items as! [PolygonChartItem])
        optionsView.addItem(itemsCell)
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsText")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                if let items = chartView.chart.items {
                    for item in items {
                        item.text?.hidden = selection == 0
                    }
                }
                chartView.redraw()
            })
        )
        
        callRadioCellsSectionChange()
    }
    
    func createItem() -> PolygonChartItem {
        let item = PolygonChartItem(0.5)
        let text = ChartText()
        text.font = UIFont.systemFont(ofSize: 11)
        text.color = Color_White
        text.textOffsetByAngle = {(text, size, angle) -> CGFloat in
            return 15
        }
        item.text = text
        updateItem(item)
        return item
    }
    
    func updateItem(_ item: PolygonChartItem) {
        item.text?.string = String(format: "%.2f", item.value)
        item.text?.hidden = radioCellSelectionForKey("ItemsText") == 0
    }
    
    func createCell(_ item: PolygonChartItem) -> SliderCell {
        return SliderCell()
            .setObject(item)
            .setSliderValue(0,1,item.value)
            .setDecimalCount(2)
            .setOnValueChange({[weak self](cell, value) in
                guard let self = self else {
                    return
                }
                let item = cell.object as! PolygonChartItem
                item.value = value
                self.updateItem(item)
                self.chartView.redraw()
            })
    }
    
}
