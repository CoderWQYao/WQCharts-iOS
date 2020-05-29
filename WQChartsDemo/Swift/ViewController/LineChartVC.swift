// https://github.com/CoderWQYao/WQCharts-iOS
//
// LineChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class LineChartVC: CoordinateChartVC<LineChartView>, ItemsOptionsDelegate {

    var curentColor: UIColor = Color_Blue
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutRectangleChartView()
    }
    
    override func chartViewDidCreate(_ chartView: LineChartView) {
        super.chartViewDidCreate(chartView)
        chartView.chart.paint?.color = curentColor
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
        
    }
    
    override func updateChartCoordinate() {
        super.updateChartCoordinate()
        chartView.padding = chartViewPadding(forSelection: radioCellSelectionForKey("Padding"))
        view.setNeedsLayout()
    }
    
    // MARK: - Items
    
    override func configChartItemsOptions() {
        super.configChartItemsOptions()
        
        optionsView.addItem(RadioCell()
            .setTitle("ItemsText")
            .setOptions(["OFF","ON"]).setSelection(0)
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
            chartView.chart.items = (items as! [LineChartItem])
            return items
        }
    }
    
    var itemsOptionTitle: String {
        return "Items"
    }
    
    func createItem(atIndex index: Int) -> Any? {
        let item = LineChartItem(CGPoint(x: CGFloat(index), y: CGFloat(Int.random(in: 0...99))))
        
        let text = ChartText()
        text.font = UIFont.systemFont(ofSize: 9)
        text.color = Color_White
        item.text = text
        
        updateItem(item)
        return item
    }
    
    func createItemCell(withItem item: Any, atIndex index: Int)  -> UIView {
        return SliderCell()
            .setObject(item)
            .setSliderValue(0,99,(item as! LineChartItem).value.y)
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
    
    func itemsDidChange(_ items: NSMutableArray) {
        chartView.chart.items = (items as! [LineChartItem])
        chartView.redraw()
    }
    
    func updateItem(_ item: LineChartItem) {
        if let text = item.text {
            text.hidden = radioCellSelectionForKey("ItemsText") == 0
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
        
        if let items = (chartView as! LineChartView).chart.items {
            for item in items {
                item.text?.string = String(format: "%ld", Int(round(item.value.y)))
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
        
        let chart = chartView.chart
        
        if keys.contains("Color") {
            let color = curentColor == Color_Blue ? Color_Red : Color_Blue
            if let paint = chart.paint {
                paint.colorTween = ChartUIColorTween(paint.color ?? .clear, color)
            }
            curentColor = color
        }
        
        if keys.contains("Values") {
            chart.items?.forEach({ (item) in
                item.valueTween = ChartCGPointTween(item.value, CGPoint(x: item.value.x, y: CGFloat(Int.random(in: 0...99))))
            })
        }
        
    }
    
    // MARK: - AnimationDelegate
    
    override func animation(_ animation: ChartAnimation, progressDidChange progress: CGFloat) {
        super.animation(animation, progressDidChange: progress)
        
        if chartView.isEqual(animation.animatable) {
            chartView.chart.items?.enumerated().forEach({ (idx, item) in
                updateSliderValue(item.value.y, forKey: "Items", atIndex: idx)
            })
        }
        
        
    }
    
}
