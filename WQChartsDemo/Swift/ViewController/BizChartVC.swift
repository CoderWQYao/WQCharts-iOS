// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// BizChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class BizChartData {
    var barValue = CGFloat(0)
    var lineValue = CGFloat(0)
    var lineValue2 = CGFloat(0)
}

class BizChartItem {
    
    var charts: [Chart]
    var datas: [BizChartData]
    
    init(_ charts: [Chart], _ datas: [BizChartData]) {
        self.charts = charts
        self.datas = datas
    }
}

class BizChartVC: BaseChartVC<BizChartView>, BizChartViewAdapter {
    
    let barWidth: CGFloat
    let barWidthHalf: CGFloat
    let dataCount: Int
    let maxDataValue: CGFloat
    let clipInset: UIEdgeInsets
    
    lazy var items: NSMutableArray = {
        return NSMutableArray()
    }()
    
    lazy var barGraphics: NSMutableArray = {
        return NSMutableArray()
    }()
    
    private var touchLocation: CGPoint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        barWidth = 5
        barWidthHalf = barWidth / 2
        dataCount = 1000
        maxDataValue = 1000
        clipInset = UIEdgeInsets(top: 0, left: -barWidthHalf, bottom: 0, right: -barWidthHalf)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.adapter = self
        chartView.separatorWidth = 10
        
        optionsView.addItem(RadioCell()
            .setTitle("Padding")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                if selection != 0 {
                    chartView.padding = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
                } else {
                    chartView.padding = .zero
                }
            })
        )
        
        // 分布模式
        optionsView.addItem(RadioCell()
            .setTitle("DistributionMode")
            .setOptions(["0","1"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.chartView.reloadData()
            })
        )
        
        // 固定BoundsX，开启可以展示出更平滑的滚动效果
        // 如果不开启，适合FixedVisiableCountDistributionRow使用
        optionsView.addItem(RadioCell()
            .setTitle("FixedBoundsX")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("FixedBoundsY")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.chartView.redraw()
            })
        )
        
        
        optionsView.addItem(RadioCell()
            .setTitle("ClipToRect")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.chartView.redraw()
            })
        )
        
        let rowsCell = ListCell()
            .setTitle("Rows")
            .setIsMutable(true)
            .setOnAppend({[weak self](cell) in
                guard let self = self else {
                    return
                }
            
                let item = self.createItem()
                self.items.add(item)
                self.chartView.reloadData()
                
                cell.addItem(self.createRowCell(item, self.items.count - 1))
                self.scrollToListCell("Rows", .Bottom, true)
            }).setOnRemove({[weak self](cell) in
                guard let self = self else {
                    return
                }

                let index = self.items.count - 1
                if index < 0 {
                    return
                }
                cell.removeItem(at: index)
                self.scrollToListCell("Rows", .Bottom, true)
                
                self.items.removeObject(at: index)
                self.chartView.reloadData()
            })
        let items = self.items
        for i in 0..<1 {
            let item = createItem()
            items.add(item)
            rowsCell.addItem(createRowCell(item, i))
        }
        optionsView.addItem(rowsCell)
        
        callRadioCellsSectionChange()
        chartView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:))))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.chartView.frame = chartContainer.bounds
    }
    
    func createItem() -> BizChartItem  {
        let charts = NSMutableArray()
        
        charts.add(AxisChart())
        charts.add(BarChart())
        
        let lineChart = LineChart()
        lineChart.shapePaint = nil
        lineChart.linePaint?.color = Color_Red
        charts.add(lineChart)
        
        let lineChart2 = LineChart()
        lineChart2.shapePaint = nil
        lineChart2.linePaint?.color = Color_Orange
        charts.add(lineChart2)
        
        return BizChartItem(charts as! [Chart], createDatas())
    }
    
    func createDatas() -> [BizChartData] {
        let datas = NSMutableArray()
        for _ in 0..<dataCount {
            let data = BizChartData()
            data.barValue = CGFloat(arc4random() % UInt32((maxDataValue + 1)))
            // 让线段不顶边
            let lineMaxValue = maxDataValue * 0.8
            data.lineValue = CGFloat(arc4random() % UInt32(lineMaxValue + 1)) + (maxDataValue - lineMaxValue) / 2
            data.lineValue2 = CGFloat(arc4random() % UInt32(lineMaxValue + 1)) + (maxDataValue - lineMaxValue) / 2
            datas.add(data)
        }
        return (datas as! [BizChartData])
    }
    
    func createRowCell(_ item: BizChartItem, _ index: Int) -> SectionCell {
        return SectionCell()
            .setObject(item)
            .setTitle(String(format: "Row%ld", index))
            .setOnReload({[weak self](cell) in
                guard let self = self else {
                    return
                }
                let item = cell.object as! BizChartItem
                item.datas = self.createDatas()
                self.chartView.redraw()
            })
    }
    
    func createAxisChartItems(_ lowerBound: CGFloat, _ upperBound: CGFloat) -> [AxisChartItem] {
        let items = NSMutableArray()
        
        // Horizontal Axis
        let horizontalCount = 5
        let horizontalStep = (upperBound - lowerBound) / CGFloat(horizontalCount - 1)
        for i in 0..<horizontalCount {
            let item = AxisChartItem(CGPoint(x: 0, y: i), CGPoint(x: 1, y: i))
            item.paint?.color = Color_White
            let text = ChartText()
            text.color = Color_White
            text.font = UIFont.systemFont(ofSize: 9)
            text.textOffsetByAngle = {(text,size,angle) -> CGFloat in
                return -(size.width / 2) - 3
            }
            text.string = String(format: "%ld", Int(round(CGFloat(i) * horizontalStep) + lowerBound))
            if i==0 {
                text.textOffset = {(text,size,angle) -> CGPoint in
                    return CGPoint(x: 0, y: -size.height / 2)
                }
            } else if i==horizontalCount - 1 {
                text.textOffset = {(text,size,angle) -> CGPoint in
                    return CGPoint(x: 0, y: size.height / 2)
                }
            } else {
                item.paint?.dashLengths = [4,2]
            }
            item.headerText = text
            items.add(item)
        }
        
        // Vertical Axis
        do {
            var item = AxisChartItem(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: horizontalCount - 1))
            item.paint?.color = Color_White
            items.add(item)
            
            item = AxisChartItem(CGPoint(x: 1, y: 0), CGPoint(x: 1, y: horizontalCount - 1))
            item.paint?.color = Color_White
            items.add(item)
        }
        
        return items as! [AxisChartItem]
    }
    
    @objc func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer)  {
        let state = gestureRecognizer.state
        if state == .began || state == .changed {
            touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        } else {
            touchLocation = nil
        }
        chartView.redraw()
    }
    
    // MARK: - BizChartViewAdapter
    
    func getRowCount(_ BizChartView: BizChartView) -> Int {
        return items.count
    }
    
    func getRow(_ BizChartView: BizChartView, _ index: Int) -> BizChartView.Row {
        let rowWidth = min(BizChartView.bounds.width, BizChartView.bounds.height) / 3
        if radioCellSelectionForKey("DistributionMode") != 0 {
            let visiableCount = Int((BizChartView.bounds.size.width - BizChartView.padding.left - BizChartView.padding.right) / (barWidth + 2))
            return FixedVisiableCountDistributionRow(rowWidth, visiableCount, dataCount)
        } else {
            return FixedItemSpacingDistributionRow(rowWidth, barWidth + 2, dataCount)
        }
    }
    
    func distributeRow(_ BizChartView: BizChartView, _ distribution: BizDistribution, _ index: Int) {
        let item = items[index] as! BizChartItem
        let axisChart = item.charts[0] as! AxisChart
        let barChart = item.charts[1] as! BarChart
        let lineChart = item.charts[2] as! LineChart
        let lineChart2 = item.charts[3] as! LineChart
        
        let distributionItems = distribution.items
        let capacity = distributionItems?.count ?? 0
        
        // Build Items
        var minValue = CGFloat(0)
        var maxValue = CGFloat(0)
        let barChartItems = NSMutableArray(capacity: capacity)
        let lineChartItems = NSMutableArray(capacity: capacity)
        let lineChartItems2 = NSMutableArray(capacity: capacity)
        for i in 0..<capacity {
            let distributionItem = distributionItems![i]
            let location = distributionItem.location
            let data = item.datas[distributionItem.index]
            let barValue = data.barValue
            let lineValue = data.lineValue
            let lineValue2 = data.lineValue2
            
            let barChartItem = BarChartItem(location, barValue)
            barChartItem.barWidth = barWidth
            barChartItem.paint?.fill?.color = Color_Gray
            barChartItem.paint?.stroke = nil
            barChartItems.add(barChartItem)
            
            lineChartItems.add(LineChartItem(CGPoint(x: location, y: lineValue)))
            lineChartItems2.add(LineChartItem(CGPoint(x: location, y: lineValue2)))
            
            let itemMinValue = min(min(barValue, lineValue),lineValue2)
            let itemMaxValue = max(max(barValue, lineValue),lineValue2)
            if i==0 {
                minValue = itemMinValue
                maxValue = itemMaxValue
            } else {
                minValue = min(minValue, itemMinValue)
                maxValue = max(maxValue, itemMaxValue)
            }
        }
        
        barChart.items = (barChartItems as! [BarChartItem])
        lineChart.items = (lineChartItems as! [LineChartItem])
        lineChart2.items = (lineChartItems2 as! [LineChartItem])
        
        // Fix Bounds
        let fixedBoundsX = radioCellSelectionForKey("FixedBoundsX") != 0
        let fixedBoundsY = radioCellSelectionForKey("FixedBoundsY") != 0
        for i in 1..<item.charts.count {
            let chart = item.charts[i] as! CoordinateChart
            
            if fixedBoundsX {
                chart.fixedMinX = distribution.lowerBound as NSNumber
                chart.fixedMaxX = distribution.upperBound as NSNumber
            } else {
                chart.fixedMinX = nil
                chart.fixedMaxX = nil
            }
            
            if fixedBoundsY {
                chart.fixedMinY = 0
                chart.fixedMaxY = maxDataValue as NSNumber
            } else {
                chart.fixedMinY = minValue as NSNumber
                chart.fixedMaxY = maxValue as NSNumber
            }
        }
        
        axisChart.items = createAxisChartItems(CGFloat(barChart.fixedMinY?.doubleValue ?? 0), CGFloat(barChart.fixedMaxY?.doubleValue ?? 0))
    }
    
    
    // 绘制的分布内容的Charts.Rect不建议改动，因为Items是按照Row.length来分布的，Rect则按照Row.width、Row.length、BizChartView.contentOffset算出。
    // 需要显示上的调整修改BizChartView.padding、Axis.rect、Context.clip等即可
    func drawRow(_ BizChartView: BizChartView, _ index: Int, _ context: CGContext) {
        let row = BizChartView.rows![index]
        let rect = row.rect
        
        let item = items[index] as! BizChartItem
        let axisChart = item.charts[0] as! AxisChart
        let barChart = item.charts[1] as! BarChart
        let lineChart = item.charts[2] as! LineChart
        let lineChart2 = item.charts[3] as! LineChart
        
        let axisGraphic = axisChart.drawGraphic(rect.inset(by: UIEdgeInsets(top: -0.5, left: -barWidthHalf - 0.5, bottom: -0.5, right: -barWidthHalf - 0.5)), context)
        
        let clipToRect = radioCellSelectionForKey("ClipToRect") != 0
        if clipToRect {
            context.clip(to: rect.inset(by: clipInset))
        }
        
        let barGraphic = barChart.drawGraphic(rect, context)
        barGraphics.add(barGraphic)
        
        lineChart.drawGraphic(rect, context)
        lineChart2.drawGraphic(rect,context)
        
        if clipToRect {
            context.resetClip()
        }
        
        axisChart.drawText(axisGraphic, context)
    }
    
    func willDraw(_ BizChartView: BizChartView, _ context: CGContext) {
        self.barGraphics = NSMutableArray(capacity: BizChartView.rows?.count ?? 0)
    }
    
    func didDraw(_ BizChartView: BizChartView, _ context: CGContext) {
        guard let touchLocation = touchLocation,
            let barGraphics = barGraphics as? [BarGraphic],
            let firstBarGraphic = barGraphics.first,
            let nearestBarGraphicItem = firstBarGraphic.findNearestItem(touchLocation, firstBarGraphic.rect.inset(by: clipInset))
            else {
            return
        }
        
        let nearestBarItem = nearestBarGraphicItem.builder as! BarChartItem
        var insideBarGraphic_op: BarGraphic? = nil
        for barGraphic in barGraphics {
            if barGraphic.rect.contains(CGPoint(x: barGraphic.rect.midX, y: touchLocation.y)) {
                insideBarGraphic_op = barGraphic
            }
        }
        
        context.saveGState()
        
        let bounds = BizChartView.bounds
        let stringX = nearestBarGraphicItem.stringStart.x
        
        context.move(to: CGPoint(x: stringX, y: bounds.minY))
        context.addLine(to: CGPoint(x: stringX, y: bounds.maxY))
        context.move(to: CGPoint(x: bounds.minX, y: touchLocation.y))
        context.addLine(to: CGPoint(x: bounds.maxX, y: touchLocation.y))
        context.setLineWidth(1)
        context.setStrokeColor(Color_White.cgColor)
        context.drawPath(using: .stroke)
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let stringAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9), NSAttributedString.Key.foregroundColor: Color_White, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let horizontalString = NSString(format: "X:%.2f", nearestBarItem.x)
        let horizontalStringSize = horizontalString.size(withAttributes: stringAttributes)
        var horizontalStringRect = CGRect(x: stringX - horizontalStringSize.width / 2 - 5, y: bounds.minY, width: horizontalStringSize.width + 10, height: horizontalStringSize.height)
        if horizontalStringRect.minX < bounds.minX {
            horizontalStringRect.origin.x = bounds.minX
        } else if horizontalStringRect.maxX > bounds.maxX {
            horizontalStringRect.origin.x = bounds.maxX - horizontalStringRect.width
        }
        context.setFillColor(Color_Tint.cgColor)
        context.fill(horizontalStringRect)
        horizontalString.draw(in: horizontalStringRect, withAttributes: stringAttributes)
   
        if let insideBarGraphic = insideBarGraphic_op {
            let verticalBoundsPoint = insideBarGraphic.convertRectPointToBounds(touchLocation)
            let verticalString = NSString(format: "Y:%.2f", verticalBoundsPoint.y)
            let verticalStringSize = verticalString.size(withAttributes: stringAttributes)
            var verticalStringRect = CGRect(x: bounds.minX, y: touchLocation.y - verticalStringSize.height / 2, width: verticalStringSize.width + 10, height: verticalStringSize.height)
            if verticalStringRect.minY < bounds.minY {
                verticalStringRect.origin.y = bounds.minY
            } else if verticalStringRect.maxY > bounds.maxY {
                verticalStringRect.origin.y = bounds.maxY - verticalStringRect.size.height
            }
            context.setFillColor(Color_Tint.cgColor)
            context.fill(verticalStringRect)
            verticalString.draw(in: verticalStringRect, withAttributes: stringAttributes)
        }
        
        context.restoreGState()
    }

}
