// 代码地址: 
// BarChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit



class BarChartVC: BarLineChartVC<BarChartView> {
    
    let barWidth: CGFloat
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        barWidth = 10
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                    chartView.chart.fixedMinY = -1
                    chartView.chart.fixedMaxY = 1
                } else {
                    chartView.chart.fixedMinY = nil
                    chartView.chart.fixedMaxY = nil
                }
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
                
                let index = chartView.chart.items?.count ?? 0
                let item = self.createItem(CGFloat(index), index % 2 == 0 ? 0.5 : -0.5)
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
        for i in 0..<4 {
            let y: CGFloat
            switch i {
            case 0:
                y = 0.4
            case 1:
                y = 0.8
            case 2:
                y = -0.8
            case 3:
                y = -0.4
            default:
                y = 0
            }
            let item = createItem(CGFloat(i),y)
            items.add(item)
            itemsCell.addItem(createCell(item))
        }
        chartView.chart.items = (items as! [BarChartItem])
        optionsView.addItem(itemsCell)
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsCornerRadius")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateItems()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsStartY")
            .setOptions(["OFF","ON"])
            .setSelection(1)
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
            .setTitle("ItemsHeaderText")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateItems()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsFooterText")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateItems()
            })
        )
        
        callRadioCellsSectionChange()
    }
    
    func createItem(_ x: CGFloat, _ y: CGFloat) -> BarChartItem {
        let item = BarChartItem(x, y)
        item.barWidth = barWidth
        
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
    
    func updateItem(_ item: BarChartItem) {
        let exchangeXY = radioCellSelectionForKey("ExchangeXY") != 0
        
        let cornerRadius = radioCellSelectionForKey("ItemsCornerRadius") != 0 ? barWidth / 3 : CGFloat(0)
        item.cornerRadius2 = cornerRadius
        item.cornerRadius3 = cornerRadius
        
        let fillColor: UIColor
        if radioCellSelectionForKey("ItemsStartY") != 0 {
            item.startY = 0
            if item.endY < 0 {
                fillColor = Color_Green
            } else {
                fillColor = Color_Red
            }
        } else {
            item.startY = nil
            fillColor = Color_Red
        }
        
        if let fillPaint = item.paint?.fill {
            switch (radioCellSelectionForKey("ItemsFill")) {
            case 1:
                fillPaint.color = fillColor
                fillPaint.shader = nil
            case 2:
                fillPaint.color = nil
                fillPaint.shader = {(paint, path, object) -> Shader? in
                    let graphic = object as! BarGraphicItem
                    return LinearGradientShader(graphic.stringStart, graphic.stringEnd, [Color_Yellow,fillColor], [0.0,0.7])
                }
            default:
                fillPaint.color = nil
                fillPaint.shader = nil
            }
        }
        
        setupStrokePaint(item.paint?.stroke, Color_White, radioCellSelectionForKey("ItemsStroke"))
        
        let string = String(format: "%.2f", item.endY)
        
        if let headerText = item.headerText {
            headerText.string = string
            headerText.hidden = radioCellSelectionForKey("ItemsHeaderText") == 0
            headerText.textOffsetByAngle = {(text, size, angle) -> CGFloat in
                if exchangeXY {
                    return 15
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
                    return 15
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
    
    func createCell(_ item: BarChartItem) -> SliderCell {
        return SliderCell()
            .setObject(item)
            .setSliderValue(-1,1,item.endY)
            .setDecimalCount(2)
            .setOnValueChange {[weak self](cell, value) in
                guard let self = self else {
                    return
                }
                
                let item = cell.object as! BarChartItem
                item.endY = value
                self.updateItem(item)
                self.chartView.redraw()
        }
    }
    
}
