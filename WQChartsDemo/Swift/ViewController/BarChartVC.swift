// https://github.com/CoderWQYao/WQCharts-iOS
//
// BarChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit



class BarChartVC: CoordinateChartVC<BarChartView>, ItemsOptionsDelegate {
    
    let barWidth = CGFloat(10)
    var currentColor: UIColor = Color_Red
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutRectangleChartView()
    }
    
    override func configChartOptions() {
        super.configChartOptions()
        
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
        
    }
    
    override func updateChartExchangeXY() {
        super.updateChartExchangeXY()
        chartView.padding = chartViewPadding(forSelection: radioCellSelectionForKey("Padding"))
        updateItems()
        view.setNeedsLayout()
    }
    
    // MARK: - Items
    
    override func configChartItemsOptions() {
        super.configChartItemsOptions()
        
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
        
    }
    
    var items: NSMutableArray {
        if let items = chartView.chart.items {
            return NSMutableArray.init(array: items)
        } else {
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
                let item = createItem(atIndex: i) as! BarChartItem
                item.endY = y
                items.add(item)
            }
            chartView.chart.items = (items as! [BarChartItem])
            return items
        }
    }
    
    var itemsOptionTitle: String {
        return "Items"
    }
    
    func createItem(atIndex index: Int) -> Any? {
        let item = BarChartItem()
        item.x = CGFloat(index)
        item.endY = index % 2 == 0 ? 0.5 : -0.5
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
    
    func createItemCell(withItem item: Any, atIndex index: Int)  -> UIView {
        return SliderCell()
            .setObject(item)
            .setSliderValue(-1,1,(item as! BarChartItem).endY)
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
    
    func itemsDidChange(_ items: NSMutableArray) {
        chartView.chart.items = (items as! [BarChartItem])
        chartView.redraw()
    }
    
    func updateItem(_ item: BarChartItem) {
        let exchangeXY = chartView.chart.exchangeXY
        
        let cornerRadius = radioCellSelectionForKey("ItemsCornerRadius") != 0 ? barWidth / 3 : CGFloat(0)
        item.cornerRadius2 = cornerRadius
        item.cornerRadius3 = cornerRadius
        
        if radioCellSelectionForKey("ItemsStartY") != 0 {
            item.startY = 0
        } else {
            item.startY = nil
        }
        
        if let fillPaint = item.paint?.fill {
            switch radioCellSelectionForKey("ItemsFill") {
            case 1:
                fillPaint.color = currentColor
                fillPaint.shader = nil
            case 2:
                fillPaint.color = currentColor
                fillPaint.shader = {(paint, path, object) -> Shader? in
                    let graphic = object as! BarGraphicItem
                    return LinearGradientShader(graphic.stringStart, graphic.stringEnd, [Color_Yellow, paint.color ?? .clear], [0.0,0.7])
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
    
    func updateItems() {
        let chartView = self.chartView
        if let items = chartView.chart.items {
            for item in items {
                updateItem(item)
            }
        }
        chartView.redraw()
    }
    
    // MARK: - ChartViewDrawDelegate
    
    override func chartViewWillDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext) {
        super.chartViewWillDraw(chartView, inRect: rect, context: context)
        
        if let items = self.chartView.chart.items {
            for item in items {
                let string = String(format: "%.2f", item.endY)
                item.headerText?.string = string
                item.footerText?.string = string
            }
        }
        
    }
    
    // MARK: - Animation
    
    override func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        super.appendAnimationKeys(animationKeys)
        animationKeys.add("Values")
        animationKeys.add("Colors")
    }
    
    override func prepareAnimationOfChartView(forKeys keys: [String]) {
        super.prepareAnimationOfChartView(forKeys: keys)
        
        let chart = chartView.chart
        
        if keys.contains("Values") {
            if let items = chart.items {
                for item in items {
                    item.transformEndY = TransformCGFloat(item.endY, CGFloat.random(in: -1...1))
                }
            }
        }
        
        if keys.contains("Colors") {
            let color = currentColor.isEqual(Color_Red) ? Color_Green : Color_Red
            if let items = chart.items {
                for item in items {
                    guard let paint = item.paint?.fill else {
                        continue
                    }
                    paint.transformColor = TransformUIColor(paint.color ?? .clear, color)
                }
            }
            currentColor = color
            let cell = findRadioCellForKey("ItemsFill")!
            if cell.selection == 0 {
                cell.selection = 1
            }
        }
        
    }
    
    // MARK: - AnimationDelegate
    
    override func animation(_ animation: Animation, progressDidChange progress: CGFloat) {
        super.animation(animation, progressDidChange: progress)
        
        if chartView.isEqual(animation.transformable) {
            if let items = chartView.chart.items {
                for (idx, item) in items.enumerated() {
                    updateSliderValue(item.endY, forKey: "Items", atIndex: idx)
                }
            }
        }
        
    }
    
}
