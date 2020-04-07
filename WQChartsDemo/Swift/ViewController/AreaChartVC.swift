// https://github.com/CoderWQYao/WQCharts-iOS
//
// AreaChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class AreaChartVC: CoordinateChartVC<AreaChartView>, ItemsOptionsDelegate {
    
    var currentColor: UIColor = Color_Blue
    
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
            .setTitle("Fill")
            .setOptions(["OFF","ON","Gradient"])
            .setSelection(2)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                guard let paint = chartView.chart.paint?.fill else {
                    return
                }
                switch (selection) {
                case 1:
                    paint.color = self.currentColor
                    paint.shader = nil
                case 2:
                    paint.color = self.currentColor
                    paint.shader = {(paint, path, object) -> Shader? in
                        guard let color = paint.color else {
                            return nil
                        }
                        let graphic = object as! AreaGraphic
                        return LinearGradientShader(graphic.stringStart, graphic.stringEnd, [color.withAlphaComponent(0.1),color], [0,1])
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
                
                self.setupStrokePaint(chartView.chart.paint?.stroke, Color_White, selection)
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
            .setTitle("ItemsHeaderText")
            .setOptions(["OFF","ON"]).setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateItems()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsFooterText")
            .setOptions(["OFF","ON"])
            .setSelection(0)
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
            for i in 0..<5 {
                let item = createItem(atIndex: i)!
                items.add(item)
            }
            chartView.chart.items = (items as! [AreaChartItem])
            return items
        }
    }
    
    var itemsOptionTitle: String {
        return "Items"
    }
    
    func createItem(atIndex index: Int) -> Any? {
        let item = AreaChartItem(CGPoint(x: CGFloat(index), y: CGFloat.random(in: 0...99)))
        
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
            .setSliderValue(0,99,(item as! AreaChartItem).value.y)
            .setDecimalCount(0)
            .setOnValueChange {[weak self](cell, value) in
                guard let self = self, let item = cell.object as? AreaChartItem else {
                    return
                }
                
                item.value.y = value
                self.updateItem(item)
                self.chartView.redraw()
        }
    }
    
    func itemsDidChange(_ items: NSMutableArray) {
        chartView.chart.items = (items as! [AreaChartItem])
        chartView.redraw()
    }
    
    func updateItem(_ item: AreaChartItem) {
        let exchangeXY = chartView.chart.exchangeXY
        
        let string = String(format: "%ld", Int(round(item.value.y)))
        
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
        
        if let items = self.chartView.chart.items{
            for item in items {
                let string = String(format: "%ld", Int(round(item.value.y)))
                item.headerText?.string = string
                item.footerText?.string = string
            }
        }
        
    }
    
    // MARK: - Animation
    
    override func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        super.appendAnimationKeys(animationKeys)
        animationKeys.add("Color")
        animationKeys.add("Values")
    }
    
    override func prepareAnimationOfChartView(forKeys keys: [String]) {
        super.prepareAnimationOfChartView(forKeys: keys)
        
        let chart = self.chartView.chart
        
        if keys.contains("Color"), let paint = chart.paint?.fill {
            let color = currentColor.isEqual(Color_Blue) ? Color_Red : Color_Blue
            paint.transformColor = TransformUIColor(paint.color ?? .clear, color)
            currentColor = color
            
            let cell = findRadioCellForKey("Fill")!
            if cell.selection == 0 {
                cell.selection = 1
            }
        }
        
        if keys.contains("Values") {
            if let items = chart.items {
                for item in items {
                    item.transformValue = TransformCGPoint(item.value, CGPoint(x: item.value.x, y: CGFloat(Int.random(in: 0...99))))
                }
            }
        }
        
    }
    
    // MARK: - AnimationDelegate
    
    override func animation(_ animation: Animation, progressDidChange progress: CGFloat) {
        super.animation(animation, progressDidChange: progress)
        
        if chartView.isEqual(animation.transformable) {
            if let items = chartView.chart.items {
                for (idx, item) in items.enumerated() {
                    updateSliderValue(item.value.y, forKey: "Items", atIndex: idx)
                }
            }
        }
        
    }
    
}
