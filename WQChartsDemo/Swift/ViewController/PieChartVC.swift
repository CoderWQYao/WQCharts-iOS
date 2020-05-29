// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class PieChartVC: RadialChartVC<PieChartView>, ItemsOptionsDelegate, PieChartViewGraphicItemClickDelegate  {
    
    class PieChartItemTag {
        
        public private(set) var color1: UIColor
        public private(set) var color2: UIColor
        
        public init(_ color1: UIColor, _ color2: UIColor) {
            self.color1 = color1
            self.color2 = color2
        }
        
        public func swapColor() {
            let tmp = color1
            color1 = color2
            color2 = tmp
        }
   
    }
    
    lazy var colors: [UIColor] = {
        return Colors
    }()
    
    override func chartViewDidCreate(_ chartView: PieChartView) {
        super.chartViewDidCreate(chartView)
        chartView.graphicItemClickDelegate = self
    }
    
    // MARK: - Items
    
    override func configChartItemsOptions() {
        super.configChartItemsOptions()
        
        optionsView.addItem(ListCell()
            .setTitle("ItemsArc1Scale")
            .addItem(SliderCell()
                .setDecimalCount(2)
                .setSliderValue(0,1,1)
                .setOnValueChange({[weak self](cell, value) in
                    self?.updateItems()
                })
            )
        )
        
        optionsView.addItem(ListCell()
            .setTitle("ItemsArc2Scale")
            .addItem(SliderCell()
                .setDecimalCount(2)
                .setSliderValue(0,1,0)
                .setOnValueChange({[weak self](cell, value) in
                    self?.updateItems()
                })
            )
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
    }
    
    var items: NSMutableArray {
        if let items = chartView.chart.items {
            return NSMutableArray.init(array: items)
        } else {
            let items = NSMutableArray()
            for i in 0..<4 {
                if let item = createItem(atIndex: i) {
                    items.add(item)
                }
            }
            chartView.chart.items = (items as! [PieChartItem])
            return items
        }
    }
    
    var itemsOptionTitle: String {
        return "Items"
    }
    
    func createItem(atIndex index: Int) -> Any? {
        if index >= self.colors.count {
            return nil
        }
        
        let item = PieChartItem(1)
        
        item.tag = PieChartItemTag(self.colors[index], self.colors[(index + 1) % self.colors.count])
        
        let text = ChartText()
        text.font = UIFont.systemFont(ofSize: 11)
        text.color = Color_White
        text.hidden = radioCellSelectionForKey("ItemsText") == 0
        item.text = text
        
        updateItem(item)
        return item
    }
    
    func createItemCell(withItem item: Any, atIndex index: Int)  -> UIView {
        return SliderCell()
            .setObject(item)
            .setSliderValue(0,1,(item as! PieChartItem).value)
            .setDecimalCount(2)
            .setOnValueChange({[weak self](cell, value) in
                guard let self = self else {
                    return
                }
                let item = cell.object as! PieChartItem
                item.value = value
                self.chartView.redraw()
            })
    }
    
    func itemsDidChange(_ items: NSMutableArray) {
        chartView.chart.items = (items as! [PieChartItem])
        chartView.redraw()
    }
    
    func updateItem(_ item: PieChartItem) {
        item.arc1Scale = sliderValue(forKey: "ItemsArc1Scale", atIndex: 0)
        item.arc2Scale = sliderValue(forKey: "ItemsArc2Scale", atIndex: 0)
        
        let tag = (item.tag as! PieChartItemTag)
        if let fillPaint = item.paint?.fill {
            switch (radioCellSelectionForKey("ItemsFill")) {
            case 1:
                fillPaint.color = tag.color1
                fillPaint.shader = nil
            case 2:
                fillPaint.color = nil
                fillPaint.shader = ChartRadialGradient(center: CGPoint(x: 0.5, y: 0.5), radius: 1, colors:[tag.color1, tag.color2])
            default:
                fillPaint.color = nil
                fillPaint.shader = nil
            }
        }
        
        setupStrokePaint(item.paint?.stroke, Color_White, radioCellSelectionForKey("ItemsStroke"))
        
        item.text?.hidden = radioCellSelectionForKey("ItemsText") == 0
    }
    
    func updateItems() {
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
        
        if let items = (chartView as! PieChartView).chart.items {
            let totalValue = PieChartItem.calcTotalValue(withItems: items)
            for item in items {
                item.text?.string = String(format: "%ld%%", Int((totalValue != 0 ? item.value / totalValue : 1) * 100))
            }
        }
    }
    
    override func chartViewDidDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext) {
        super.chartViewDidDraw(chartView, inRect: rect, context: context)
        
    }
    
    // MARK: - PieChartViewGraphicItemClickDelegate
    
    func pieChartView(_ pieChartView: PieChartView, graphicItemDidClick graphicItem: PieGraphicItem) {
        let item = graphicItem.builder as! PieChartItem
        item.driftRatio = item.driftRatio == 0 ? 0.3 : 0
        pieChartView.redraw()
        
        let index = pieChartView.chart.items?.firstIndex(of: item)
        print("pieChartView:","graphicItemDidClick:",index != nil ? index! : NSNotFound)
    }
    
    // MARK: - Animation
    
    override func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        super.appendAnimationKeys(animationKeys)
        
        animationKeys.add("Values")
        animationKeys.add("Arc1s")
        animationKeys.add("Arc2s")
        animationKeys.add("Drifts")
        animationKeys.add("Colors")
    }
    
    override func prepareAnimationOfChartView(forKeys keys: [String]) {
        super.prepareAnimationOfChartView(forKeys: keys)
        
        let chart = chartView.chart
        
        if keys.contains("Values") {
            chart.items?.forEach({ (item) in
                item.valueTween = ChartCGFloatTween(item.value, CGFloat.random(in: 0...1))
            })
        }
        
        if keys.contains("Arc1s") {
            var arc1Scale: CGFloat = 1
            chart.items?.forEach({ (item) in
                arc1Scale = item.arc1Scale == 1 ? 0.5 : 1
                item.arc1ScaleTween = ChartCGFloatTween(item.arc1Scale, arc1Scale)
            })
            updateSliderValue(arc1Scale, forKey: "ItemsArc1Scale", atIndex: 0)
        }
        
        if keys.contains("Arc2s") {
            var arc2Scale: CGFloat = 0
            chart.items?.forEach({ (item) in
                arc2Scale = item.arc2Scale == 0 ? 0.5 : 0
                item.arc2ScaleTween = ChartCGFloatTween(item.arc2Scale, arc2Scale)
            })
            updateSliderValue(arc2Scale, forKey: "ItemsArc2Scale", atIndex: 0)
        }
        
        if keys.contains("Colors") {
            chart.items?.forEach({ (item) in
                let tag = item.tag as! PieChartItemTag
                tag.swapColor()
                if let paint = item.paint?.fill {
                   if let color = paint.color {
                      paint.colorTween = ChartUIColorTween(color, tag.color1)
                   }
                   if let shader = paint.shader as? ChartRadialGradient {
                    shader.colorsTween = ChartUIColorArrayTween(shader.colors, [tag.color1, tag.color2])
                   }
                }
            })
        }
        
        if keys.contains("Drifts") {
            chart.items?.forEach({ (item) in
                item.driftRatioTween = ChartCGFloatTween(item.driftRatio, item.driftRatio == 0 ? 0.3 : 0)
            })
        }
        
    }
    
    // MARK: - AnimationDelegate
    
    override func animation(_ animation: ChartAnimation, progressDidChange progress: CGFloat) {
        super.animation(animation, progressDidChange: progress)
        
        if chartView.isEqual(animation.animatable) {
            chartView.chart.items?.enumerated().forEach({ (idx, item) in
                updateSliderValue(item.value, forKey: "Items", atIndex: idx)
            })
        }
        
    }
    
}
