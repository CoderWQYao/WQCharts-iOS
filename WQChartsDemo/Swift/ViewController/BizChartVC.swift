// https://github.com/CoderWQYao/WQCharts-iOS
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

class BizChartVC: BaseChartVC<BizChartView>, ItemsOptionsDelegate, BizChartViewAdapter, ChartAnimatable {
    
    let barWidth: CGFloat
    let barWidthHalf: CGFloat
    let dataCount: Int
    let maxDataValue: CGFloat
    let clipToRectInset: UIEdgeInsets
    
    var clipRect: CGRect?
    var clipRectTween: ChartCGRectTween?
    
    lazy var barGraphics: NSMutableArray = {
        return NSMutableArray()
    }()
    
    private var touchLocation: CGPoint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        barWidth = 5
        barWidthHalf = barWidth / 2
        dataCount = 1000
        maxDataValue = 1000
        clipToRectInset = UIEdgeInsets(top: 0, left: -barWidthHalf, bottom: 0, right: -barWidthHalf)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.chartView.frame = chartContainer.bounds
    }
    
    override func chartViewDidCreate(_ chartView: BizChartView) {
        super.chartViewDidCreate(chartView)
        chartView.adapter = self
        chartView.separatorWidth = 10
        chartView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:))))
    }
    
    override func configChartOptions() {
        super.configChartOptions()
        
        optionsView.addItem(RadioCell()
            .setTitle("Padding")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak chartView](cell, selection) in
                guard let chartView = chartView else {
                    return
                }
                if selection != 0 {
                    chartView.padding = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
                } else {
                    chartView.padding = .zero
                }
            })
        )
        
        // DistributionMode see also bizChartView:rowAtIndex
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
        
    }
    
    // MARK: - Items
    
    lazy var items: NSMutableArray = {
        let items = NSMutableArray()
        for i in 0..<1 {
            let item = createItem(atIndex: i)!
            items.add(item)
        }
        return items
    }()
    
    var itemsOptionTitle: String {
        return "Rows"
    }
    
    func createItem(atIndex index: Int) -> Any? {
        let charts = NSMutableArray()
        
        charts.add(AxisChart())
        charts.add(BarChart())
        
        let lineChart = LineChart()
        lineChart.paint?.color = Color_Red
        charts.add(lineChart)
        
        let lineChart2 = LineChart()
        lineChart2.paint?.color = Color_Orange
        charts.add(lineChart2)
        
        return BizChartItem(charts as! [Chart], createDatas())
    }
    
    func createItemCell(withItem item: Any, atIndex index: Int)  -> UIView {
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
    
    func itemsDidChange(_ items: NSMutableArray) {
        chartView.reloadData()
    }
    
    func createDatas() -> [BizChartData] {
        let datas = NSMutableArray()
        for _ in 0..<dataCount {
            let data = BizChartData()
            data.barValue = CGFloat.random(in: 0...maxDataValue)
            // 让线段不顶边
            let lineMinValue = maxDataValue * 0.2
            let lineMaxValue = maxDataValue * 0.8
            data.lineValue = CGFloat.random(in: lineMinValue...lineMaxValue)
            data.lineValue2 = CGFloat.random(in: lineMinValue...lineMaxValue)
            datas.add(data)
        }
        return (datas as! [BizChartData])
    }
    
    // MARK: - BizChartViewAdapter
    
    func numberOfRowsInBizChartView(_ bizChartView: BizChartView) -> Int {
        return items.count
    }
    
    func bizChartView(_ bizChartView: BizChartView, rowAtIndex index: Int) -> BizChartView.Row {
        let rowWidth = min(bizChartView.bounds.width, bizChartView.bounds.height) / 3
        if radioCellSelectionForKey("DistributionMode") != 0 {
            // The items are distributed evenly along the row in visible area
            let visiableCount = Int((bizChartView.bounds.size.width - bizChartView.padding.left - bizChartView.padding.right) / (barWidth + 2))
            return FixedVisiableCountDistributionRow(rowWidth, visiableCount, dataCount)
        } else {
            // The items are distributed at regular intervals
            return FixedItemSpacingDistributionRow(rowWidth, barWidth + 2, dataCount)
        }
    }
    
    func bizChartView(_ bizChartView: BizChartView, distributeRowForDistributionPath distributionPath: DistributionPath, atIndex index: Int) {
        let item = items[index] as! BizChartItem
        let axisChart = item.charts[0] as! AxisChart
        let barChart = item.charts[1] as! BarChart
        let lineChart = item.charts[2] as! LineChart
        let lineChart2 = item.charts[3] as! LineChart
        
        let distributionPathItems = distributionPath.items
        let capacity = distributionPathItems?.count ?? 0
        
        // Build Items
        var minValue = CGFloat(0)
        var maxValue = CGFloat(0)
        let barChartItems = NSMutableArray(capacity: capacity)
        let lineChartItems = NSMutableArray(capacity: capacity)
        let lineChartItems2 = NSMutableArray(capacity: capacity)
        for i in 0..<capacity {
            let distributionPathItem = distributionPathItems![i]
            let location = distributionPathItem.location
            let data = item.datas[distributionPathItem.index]
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
                chart.fixedMinX = distributionPath.lowerBound as NSNumber
                chart.fixedMaxX = distributionPath.upperBound as NSNumber
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
    func bizChartView(_ bizChartView: BizChartView, drawRowAtIndex index: Int, inContext context: CGContext) {
        let row = bizChartView.rows![index]
        let rect = row.rect
        
        let item = items[index] as! BizChartItem
        let axisChart = item.charts[0] as! AxisChart
        let barChart = item.charts[1] as! BarChart
        let lineChart = item.charts[2] as! LineChart
        let lineChart2 = item.charts[3] as! LineChart
        
        let axisGraphic = axisChart.drawGraphic(rect.inset(by: UIEdgeInsets(top: -0.5, left: -barWidthHalf - 0.5, bottom: -0.5, right: -barWidthHalf - 0.5)), context)
        
        let clipToRect = radioCellSelectionForKey("ClipToRect") != 0
        if clipToRect {
            context.clip(to: rect.inset(by: clipToRectInset))
            
        }
        
        if let clipRect = clipRect {
            context.clip(to: clipRect)
        }
        
        
        let barGraphic = barChart.drawGraphic(rect, context)
        barGraphics.add(barGraphic)
        
        lineChart.drawGraphic(rect, context)
        lineChart2.drawGraphic(rect, context)
        
        if clipToRect || clipRect != nil {
            context.resetClip()
        }
        
        axisChart.drawText(axisGraphic, context)
    }
    
    func bizChartViewWillDraw(_ bizChartView: BizChartView, inContext context: CGContext) {
        self.barGraphics = NSMutableArray(capacity: bizChartView.rows?.count ?? 0)
    }
    
    func bizChartViewDidDraw(_ bizChartView: BizChartView, inContext context: CGContext) {
        drawTouchFocus(context)
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
            
            let textBlocks = ChartTextBlocks()
            textBlocks.offsetByAngle = {(text,size,angle) -> CGFloat in
                return -(size.width / 2) - 3
            }
            if i==0 {
                textBlocks.offset = {(text,size,angle) -> CGPoint in
                    return CGPoint(x: 0, y: -size.height / 2)
                }
            } else if i==horizontalCount - 1 {
                textBlocks.offset = {(text,size,angle) -> CGPoint in
                    return CGPoint(x: 0, y: size.height / 2)
                }
            } else {
                item.paint?.dashLengths = [4,2]
            }
            text.delegateUsingBlocks = textBlocks
            item.headerText = text
            
            text.string = String(format: "%ld", Int(round(CGFloat(i) * horizontalStep) + lowerBound))
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
    
    func drawTouchFocus(_ context: CGContext)  {
        
        guard let touchLocation = touchLocation,
            let barGraphics = barGraphics as? [BarGraphic],
            let firstBarGraphic = barGraphics.first,
            let nearestBarGraphicItem = firstBarGraphic.findNearestItem(touchLocation, firstBarGraphic.rect.inset(by: clipToRectInset))
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
        
        let bounds = chartView.bounds
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
    
    // MARK: - Animation
    
    override func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        super.appendAnimationKeys(animationKeys)
        animationKeys.add("Padding")
        animationKeys.add("Clip")
    }
    
    override func prepareAnimationOfChartView(forKeys keys: [String]) {
        super.prepareAnimationOfChartView(forKeys: keys)
        
        if keys.contains("Padding") {
            let paddingCell = findRadioCellForKey("Padding")!
            let padding: UIEdgeInsets
            if paddingCell.selection == 0  {
                padding = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
            } else {
                padding = .zero
            }
            chartView.paddingTween = ChartUIEdgeInsetsTween(chartView.padding, padding)
            paddingCell.selection = paddingCell.selection == 0 ? 1 : 0
        }
        
    }
    
    override func appendAnimations(inArray array: NSMutableArray, forKeys keys: [String]) {
        super.appendAnimations(inArray: array, forKeys: keys)
        
        if keys.contains("Clip") {
            let rect = chartView.bounds
            let isReversed = Bool.random()
            if isReversed {
                clipRectTween = ChartCGRectTween(
                    CGRect(x: rect.maxX, y: rect.minY, width: 0, height: rect.height),
                    CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                )
            } else {
                clipRectTween = ChartCGRectTween(
                    CGRect(x: rect.minX, y: rect.minY, width: 0, height: rect.height),
                    CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                )
            }
            array.add(ChartAnimation(self, animationDuration, animationInterpolator))
        }
        
    }
    
    // MARK: - Animatable
    
    func transform(_ t: CGFloat) {
        clipRect = clipRectTween?.lerp(t)
    }
    
    func clearAnimationElements() {
        clipRectTween = nil
        clipRect = nil
    }
    
    // MARK: - Action
    
    @objc func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer)  {
        let state = gestureRecognizer.state
        if state == .began || state == .changed {
            touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        } else {
            touchLocation = nil
        }
        chartView.redraw()
    }
    
}
