// https://github.com/CoderWQYao/WQCharts-iOS
//
// AxisChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class AxisChartVC: CoordinateChartVC<AxisChartView> {
    
    lazy var horizontalItems: NSMutableArray = {
        let horizontalItems = NSMutableArray()
        return horizontalItems
    }()
    
    lazy var verticalItems: NSMutableArray = {
        let verticalItems = NSMutableArray()
        return verticalItems
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = chartContainer.bounds.width
        let height = chartContainer.bounds.height
        let fitSize = min(width, height)
        self.chartView.frame = CGRect(x: (width - fitSize) / 2, y: (height - fitSize) / 2, width: fitSize, height: fitSize)
    }

    override func configChartOptions() {
        super.configChartOptions()

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
    }
    
    override func chartViewPadding(forSelection selection: Int) -> UIEdgeInsets {
        let padding: CGFloat = selection != 0 ? 30 : 0
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    // MARK: - Items
    
    func createItem(_ start: CGPoint, _ end: CGPoint) -> AxisChartItem {
        let item = AxisChartItem(start,end)
        setupStrokePaint(item.paint, Color_White, 1)
        
        let headerText = ChartText()
        headerText.font = UIFont.systemFont(ofSize: 9)
        headerText.color = Color_White
        let headerTextBlocks = ChartTextBlocks()
        headerTextBlocks.offsetByAngle = {(text, size, angle) -> CGFloat in
            return 15
        }
        headerText.delegateUsingBlocks = headerTextBlocks
        item.headerText = headerText
        
        let footerText = ChartText()
        footerText.font = UIFont.systemFont(ofSize: 9)
        footerText.color = Color_White
        let footerTextBlocks = ChartTextBlocks()
        footerTextBlocks.offsetByAngle = {(text, size, angle) -> CGFloat in
            return 15
        }
        footerText.delegateUsingBlocks = footerTextBlocks
        item.footerText = footerText
        
        updateItem(item)
        return item
    }
    
    func updateItem(_ item: AxisChartItem) {
        item.headerText?.hidden = radioCellSelectionForKey("ItemsHeaderText") == 0
        item.footerText?.hidden = radioCellSelectionForKey("ItemsFooterText") == 0
    }
    
    func resetItems() {
        let horizontalCount = sliderIntegerValue(forKey: "HorizontalItems", atIndex: 0)
        let verticalCount = sliderIntegerValue(forKey: "VerticalItems", atIndex: 0)
        let maxX: CGFloat = verticalCount > 1 ? CGFloat(verticalCount - 1) : 1
        let maxY: CGFloat = horizontalCount > 1 ? CGFloat(horizontalCount - 1) : 1
        
        let chartView = self.chartView
        chartView.chart.fixedMinX = 0
        chartView.chart.fixedMaxX = maxX as NSNumber
        chartView.chart.fixedMinY = 0
        chartView.chart.fixedMaxY = maxY as NSNumber
        
        let horizontalItems = self.horizontalItems
        horizontalItems.removeAllObjects()
        for i in 0..<horizontalCount {
            let item = createItem(CGPoint(x: 0, y: CGFloat(i)), CGPoint(x: maxX, y: CGFloat(i)))
            horizontalItems.add(item)
        }
        
        let verticalItems = self.verticalItems
        verticalItems.removeAllObjects()
        for i in 0..<verticalCount {
            let item = createItem(CGPoint(x: CGFloat(i), y: 0), CGPoint(x: CGFloat(i), y: maxY))
            verticalItems.add(item)
        }
        
        let items = NSMutableArray(capacity: horizontalCount + verticalCount)
        items.addObjects(from: horizontalItems as! [Any])
        items.addObjects(from: verticalItems as! [Any])
        chartView.chart.items = (items as! [AxisChartItem])
        chartView.redraw()
    }
    
    // MARK: - ChartViewDrawDelegate
    
    override func chartViewWillDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext) {
        super.chartViewWillDraw(chartView, inRect: rect, context: context)
        
        if let items = self.chartView.chart.items {
            for item in items {
                item.headerText?.string = String(format: "%.f,%.f", item.start.x, item.start.y)
                item.footerText?.string = String(format: "%.f,%.f", item.end.x, item.end.y)
            }
        }
    }
    
    // MARK: - Animation
    
    override func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        super.appendAnimationKeys(animationKeys)
        animationKeys.add("Values")
    }
    
    override func prepareAnimationOfChartView(forKeys keys: [String]) {
        super.prepareAnimationOfChartView(forKeys: keys)
        
        let chartView = self.chartView
        
        if keys.contains("Values"), let graphic = chartView.graphic {
            let horizontalItems = self.horizontalItems as! [AxisChartItem]
            for i in 0..<horizontalItems.count {
                let item = horizontalItems[i]
                item.endTween = ChartCGPointTween(item.start, CGPoint(x: graphic.bounds.maxX, y: CGFloat(i)))
            }
            
            let verticalItems = self.verticalItems as! [AxisChartItem]
            for i in 0..<verticalItems.count {
                let item = verticalItems[i]
                item.endTween = ChartCGPointTween(item.start, CGPoint(x: CGFloat(i), y: graphic.bounds.maxY))
            }
        }
        
    }
    
    
}
