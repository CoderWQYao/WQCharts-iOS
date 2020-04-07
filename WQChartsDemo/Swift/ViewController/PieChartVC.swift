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
    
    class PieChartItemTag: Transformable {
        
        let color1: UIColor
        let color2: UIColor
        
        public init(_ color1: UIColor, _ color2: UIColor) {
            self.color1 = color1
            self.color2 = color2
        }
        
        var currentColor1 = UIColor.clear
        var currentColor2 = UIColor.clear
        
        var transformColor1: TransformUIColor?
        var transformColor2: TransformUIColor?
        
        var colorFlag = false
        
        // MARK: - Transformable
        
        func nextTransform(_ progress: CGFloat) {
            if let transformColor1 = transformColor1 {
                currentColor1 = transformColor1.valueForProgress(progress)
            }
            
            if let transformColor2 = transformColor2 {
                currentColor2 = transformColor2.valueForProgress(progress)
            }
        }
        
        func clearTransforms() {
            transformColor1 = nil
            transformColor2 = nil
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
        tag.currentColor1 = tag.color1
        tag.currentColor2 = tag.color2
        
        if let fillPaint = item.paint?.fill {
            switch (radioCellSelectionForKey("ItemsFill")) {
            case 1:
                fillPaint.color = tag.currentColor1
                fillPaint.shader = nil
            case 2:
                fillPaint.color = tag.currentColor1
                fillPaint.shader = {(paint, path, object) -> Shader? in
                    let graphic = object as! PieGraphicItem
                    let builder = graphic.builder as! PieChartItem
                    let tag = builder.tag as! PieChartItemTag
                    return RadialGradientShader(graphic.center, graphic.arc1Radius, [tag.currentColor1, tag.currentColor2], [0,1])
                }
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
            let totalValue = PieChartItem.getTotalValue(items)
            for item in items {
                item.paint?.fill?.color = radioCellSelectionForKey("ItemsFill") != 0 ? (item.tag as! PieChartItemTag).currentColor1 : nil
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
        
        if keys.contains("Values"), let items = chart.items {
            for item in items {
                item.transformValue = TransformCGFloat(item.value, CGFloat.random(in: 0...1))
            }
        }
        
        if keys.contains("Arc1s"), let items = chart.items {
            var arc1Scale: CGFloat = 1
            for item in items {
                arc1Scale = item.arc1Scale == 1 ? 0.5 : 1
                item.transformArc1Scale = TransformCGFloat(item.arc1Scale, arc1Scale)
            }
            updateSliderValue(arc1Scale, forKey: "ItemsArc1Scale", atIndex: 0)
        }
        
        if keys.contains("Arc2s"), let items = chart.items {
            var arc2Scale: CGFloat = 0
            for item in items {
                arc2Scale = item.arc2Scale == 0 ? 0.5 : 0
                item.transformArc2Scale = TransformCGFloat(item.arc2Scale, arc2Scale)
            }
            updateSliderValue(arc2Scale, forKey: "ItemsArc2Scale", atIndex: 0)
        }
        
        if keys.contains("Drifts"), let items = chart.items {
            for item in items {
                item.transformDriftRatio = TransformCGFloat(item.driftRatio, item.driftRatio == 0 ? 0.3 : 0)
            }
        }
        
    }
    
    override func appendAnimations(inArray array: NSMutableArray, forKeys keys: [String]) {
        super.appendAnimations(inArray: array, forKeys: keys)
        
        let chart = chartView.chart
        
        if keys.contains("Colors"), let items = chart.items {
            for item in items {
                let tag = item.tag as! PieChartItemTag
                tag.transformColor1 = TransformUIColor(tag.currentColor1, tag.colorFlag ? tag.color1 : tag.color2)
                tag.transformColor2 = TransformUIColor(tag.currentColor2, tag.colorFlag ? tag.color2 : tag.color1)
                tag.colorFlag = !tag.colorFlag
                array.add(Animation(tag, animationDuration, animationInterpolator))
            }
            
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
                    updateSliderValue(item.value, forKey: "Items", atIndex: idx)
                }
            }
        }
        
    }
    
}
