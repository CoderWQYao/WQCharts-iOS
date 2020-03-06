// 代码地址: 
// AxisChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class AxisChartVC: BaseChartVC<AxisChartView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsView.addItem(RadioCell()
            .setTitle("Padding")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                let padding: CGFloat = selection != 0 ? 30 : 0
                chartView.padding = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ExchangeXY")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                chartView.chart.exchangeXY = selection != 0
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ReverseX")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                chartView.chart.reverseX = selection != 0
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ReverseY")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                chartView.chart.reverseY = selection != 0
                chartView.redraw()
            })
        )
        
        optionsView.addItem(ListCell()
            .setTitle("HorizontalItems")
            .addItem(SliderCell()
                .setSliderValue(0,5,1)
                .setDecimalCount(0)
                .setOnValueChange({[weak self](cell, value) in
                    self?.resetItems()
                })
            )
        )
        
        optionsView.addItem(ListCell()
            .setTitle("VerticalItems")
            .addItem(SliderCell()
                .setSliderValue(0,5,1)
                .setDecimalCount(0)
                .setOnValueChange({[weak self](cell, value) in
                    self?.resetItems()
                })
            )
        )
        
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsHeaderText")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                if let items = chartView.chart.items {
                    for item in items {
                        item.headerText?.hidden = selection == 0
                    }
                }
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsFooterText")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                
                if let items = chartView.chart.items {
                    for item in items {
                        item.footerText?.hidden = selection == 0
                    }
                }
                chartView.redraw()
            })
        )
        
        resetItems()
        callRadioCellsSectionChange()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = chartContainer.bounds.width
        let height = chartContainer.bounds.height
        let fitSize = min(width, height)
        self.chartView.frame = CGRect(x: (width - fitSize) / 2, y: (height - fitSize) / 2, width: fitSize, height: fitSize)
    }
    
    func createItem(_ start: CGPoint, _ end: CGPoint) -> AxisChartItem {
        let item = AxisChartItem(start,end)
        setupStrokePaint(item.paint, Color_White, 1)
        
        let headerText = ChartText()
        headerText.font = UIFont.systemFont(ofSize: 9)
        headerText.color = Color_White
        headerText.textOffsetByAngle = {(text, size, angle) -> CGFloat in
            return 15
        }
        item.headerText = headerText
        
        let footerText = ChartText()
        footerText.font = UIFont.systemFont(ofSize: 9)
        footerText.color = Color_White
        footerText.textOffsetByAngle = {(text, size, angle) -> CGFloat in
            return 15
        }
        item.footerText = footerText
        
        updateItem(item)
        return item
    }
    
    func updateItem(_ item: AxisChartItem) {
        if let headerText = item.headerText {
            headerText.string = String(format: "%.f,%.f", item.start.x, item.start.y)
            headerText.hidden = radioCellSelectionForKey("ItemsHeaderText") == 0
        }
        
        if let footerText = item.footerText {
            footerText.string = String(format: "%.f,%.f", item.end.x, item.end.y)
            footerText.hidden = radioCellSelectionForKey("ItemsFooterText") == 0
        }
    }
    
    func resetItems() {
        let items = NSMutableArray()
        
        let horizontalCount = getSliderIntegerValue("HorizontalItems", 0)
        let verticalCount = getSliderIntegerValue("VerticalItems", 0)
        
        for i in 0..<horizontalCount {
            let item = createItem(CGPoint(x: 0, y: CGFloat(i)), CGPoint(x: verticalCount > 1 ? CGFloat(verticalCount - 1) : 1, y: CGFloat(i)))
            items.add(item)
        }
        
        for i in 0..<verticalCount {
            let item = createItem(CGPoint(x: CGFloat(i), y: 0), CGPoint(x: CGFloat(i), y: horizontalCount > 1 ? CGFloat(horizontalCount - 1) : 1))
            items.add(item)
        }
        
        chartView.chart.items = items as? [AxisChartItem]
        chartView.redraw()
    }
}
