// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class PieChartVC: RadialChartVC<PieChartView> {
    
    class PieChartItemTag {
        var fillColor = UIColor.clear
        var gradientColor = UIColor.clear
        var separated = false
    }
    
    lazy var colors: [UIColor] = {
        return Colors
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemsCell = ListCell()
            .setTitle("Items")
            .setIsMutable(true)
            .setOnAppend({[weak self](cell) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                let index = chartView.chart.items?.count ?? 0
                if index >= Colors.count {
                    return
                }
                
                let item = self.createItem(index)
                chartView.chart.items?.append(item)
                self.updateItemsText(chartView.chart.items)
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
                self.updateItemsText(chartView.chart.items)
                chartView.redraw()
            })
        
        let items = NSMutableArray()
        for i in 0..<4 {
            let item = createItem(i)
            items.add(item)
            itemsCell.addItem(createCell(item))
        }
        updateItemsText(items as! [PieChartItem])
        chartView.chart.items = (items as! [PieChartItem])
        optionsView.addItem(itemsCell)
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsRing")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateItems()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsFill")
            .setOptions(["OFF","ON","Gradient"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateItems()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsStroke")
            .setOptions(["OFF","ON","Dash"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateItems()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsText")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateItems()
            })
        )
        
        chartView.onGraphicItemClick = {(chartView, graphicItem) in
            let item = graphicItem.builder as! PieChartItem
            let tag = item.tag as! PieChartItemTag
            tag.separated = !tag.separated
            item.offsetFactor = tag.separated ? 0.3 : 0
            chartView.redraw()
        }
        
        callRadioCellsSectionChange()
    }
    
    func createItem(_ index: Int) -> PieChartItem {
        let item = PieChartItem(1)
        
        let tag = PieChartItemTag()
        if index < self.colors.count {
            tag.fillColor = self.colors[index]
            tag.gradientColor = self.colors[(index + 1) % self.colors.count]
        }
        item.tag = tag
        
        let text = ChartText()
        text.font = UIFont.systemFont(ofSize: 11)
        text.color = Color_White
        text.hidden = radioCellSelectionForKey("ItemsText") == 0
        item.text = text
        
        updateItem(item)
        return item
    }
    
    func updateItem(_ item: PieChartItem) {
        if let fillPaint = item.paint?.fill {
            switch (radioCellSelectionForKey("ItemsFill")) {
            case 1:
                fillPaint.color = (item.tag as! PieChartItemTag).fillColor
                fillPaint.shader = nil
            case 2:
                fillPaint.color = nil
                fillPaint.shader = {(paint, path, object) -> Shader? in
                    let graphic = object as! PieGraphicItem
                    let builder = graphic.builder as! PieChartItem
                    let tag = builder.tag as! PieChartItemTag
                    return RadialGradientShader(graphic.center,graphic.outerRadius,[tag.gradientColor,tag.fillColor],[0,1])
                }
            default:
                fillPaint.color = nil
                fillPaint.shader = nil
            }
        }
        
        setupStrokePaint(item.paint?.stroke, Color_White, radioCellSelectionForKey("ItemsStroke"))
        
        item.innerFactor = radioCellSelectionForKey("ItemsRing") != 0 ? 0.3 : 0
        item.text?.hidden = radioCellSelectionForKey("ItemsText") == 0
    }
    
    func updateItems() {
        if let items = chartView.chart.items {
            updateItemsText(items)
            for item in items {
                updateItem(item)
            }
        }
        chartView.redraw()
    }
    
    func updateItemsText(_ items: [PieChartItem]?) {
        guard let items = items else {
            return
        }
        let totalValue = PieChartItem.getTotalValue(items)
        for item in items {
            guard let text = item.text else {
                continue
            }
            text.string = String(format: "%ld%%", Int((totalValue != 0 ? item.value / totalValue : 1) * 100))
        }
    }
    
    func createCell(_ item: PieChartItem) -> SliderCell {
        return SliderCell()
            .setObject(item)
            .setSliderValue(0,1,item.value)
            .setDecimalCount(2)
            .setOnValueChange({[weak self](cell, value) in
                guard let self = self else {
                    return
                }
                let item = cell.object as! PieChartItem
                item.value = value
                self.updateItemsText(self.chartView.chart.items)
                self.chartView.redraw()
            })
    }
    
}
