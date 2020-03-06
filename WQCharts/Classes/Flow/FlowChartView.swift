// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// FlowChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 流式图表适配器
@objc(WQFlowChartViewAdapter)
public protocol FlowChartViewAdapter {
    
    /// 返回行数
    @objc(numberOfRowsInHorizontalFlowChartView:)
    func getRowCount(_ flowChartView: FlowChartView) -> Int
    
    /// 返回行
    @objc(flowChartView:rowAtIndex:)
    func getRow(_ flowChartView: FlowChartView, _ index: Int) -> FlowChartView.Row

    /// 分布行
    @objc(flowChartView:distributionForRow:atIndex:)
    optional func distributeRow(_ flowChartView: FlowChartView, _ distribution: FlowDistribution, _ index: Int)
    
    /// 绘制行
    @objc(flowChartView:drawRowAtIndex:inContext:)
    optional func drawRow(_ flowChartView: FlowChartView, _ index: Int, _ context: CGContext)

    @objc(flowChartViewWillDraw:inContext:)
    optional func willDraw(_ flowChartView: FlowChartView, _ context: CGContext)
    
    @objc(flowChartViewDidDraw:inContext:)
    optional func didDraw(_ flowChartView: FlowChartView, _ context: CGContext)
      
}

@objc(WQFlowChartViewDistributionRow)
public protocol FlowChartViewDistributionRow {
   
    @objc func distribute(_ lowerBound: CGFloat, _ upperBound: CGFloat) -> FlowDistribution
    
}

/// 流式图表
@objc(WQFlowChartView)
open class FlowChartView: ScrollChartView {
    
    /// 表示流式图表中的行
    @objc(WQFlowChartViewRow)
    open class Row: NSObject {
        
        /// 行宽。如果是水平方向分布，则表示在视图空间的高度，否则表示在视图空间的宽度
        @objc public let width: CGFloat
        /// 长度。如果是水平方向分布，则表示在视图空间的宽度，否则表示在视图空间的高度。值由measureLength返回。
        @objc internal(set) public var length = CGFloat(0)
        /// 视图空间的矩形
        @objc internal(set) public var rect = CGRect.zero
        
        @objc(initWithWidth:)
        public init(_ width: CGFloat) {
            self.width = width
            super.init()
        }
        
        /// 测量长度
        /// - Return 返回测量长度
        @objc(measureLengthWithVisualRange:)
        open func measureLength(_ visualRange: CGFloat) -> CGFloat {
            return visualRange
        }
    
    }
    
    override func prepare() {
        super.prepare()
        
        isDirectionalLockEnabled = true
    }
    
    /// 内间距
    @objc open var padding = UIEdgeInsets.zero {
         didSet {
             reloadData()
         }
    }
    
    /// 适配器
    @objc open weak var adapter: FlowChartViewAdapter? {
        didSet {
            reloadData()
        }
    }
    
    /// 分割器宽度，与行宽的作用一致
    @objc open var separatorWidth = CGFloat(0) {
        didSet {
            redraw()
        }
    }
    
    @objc open private(set) var rows: [Row]?
    
    /// 用于标记是否需要重新加载数据
    private var needsReloadData = false
    /// 用于标记layout记录
    private var layoutSize = CGSize.zero
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        if !needsReloadData && layoutSize.equalTo(size) {
            return
        }
        
        needsReloadData = false
        layoutSize = size
        redraw()
        
        guard let adapter = adapter else {
            contentSize = .zero
            return
        }

        let padding = self.padding
        var contentWidth = CGFloat(0)
        var contentHeight = CGFloat(0)
        
        let rowCount = adapter.getRowCount(self)
        let rows = NSMutableArray(capacity: rowCount)
        
        for i in 0..<rowCount {
            let row = adapter.getRow(self, i)
            let length = row.measureLength(size.width - padding.left - padding.right)
            row.length = length
            rows.add(row)
            contentWidth = max(contentWidth, length)
            contentHeight += row.width
        }
        contentHeight += rowCount > 1 ? CGFloat(rowCount - 1) * separatorWidth : 0
        
        contentWidth += padding.left + padding.right
        contentHeight += padding.top + padding.bottom
        
        contentWidth = reviseSize(contentWidth)
        contentHeight = reviseSize(contentHeight)
         
        self.rows = rows as? [Row]
        contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext(), let adapter = adapter else {
            return
        }
        
        adapter.willDraw?(self, context)
        
        let bounds = self.bounds
        
        let contentOffset = self.contentOffset
        let contentSize = self.contentSize
        
        var bouncesOffsetX = CGFloat(0)
        if contentOffset.x < 0 {
            bouncesOffsetX = -contentOffset.x
        } else if contentOffset.x > contentSize.width - min(contentSize.width, bounds.width) {
            bouncesOffsetX = contentSize.width - min(contentSize.width, bounds.width) - contentOffset.x
        }
        
        var bouncesOffsetY = CGFloat(0)
        if contentOffset.y < 0 {
            bouncesOffsetY = -contentOffset.y
        } else if contentOffset.y > contentSize.height - min(contentSize.height, bounds.height) {
            bouncesOffsetY = contentSize.height - min(contentSize.height, bounds.height) - contentOffset.y
        }
        
        var contentBounds = bounds.inset(by: padding)
        contentBounds = contentBounds.offsetBy(dx: bouncesOffsetX, dy: bouncesOffsetY)
        let padding = self.padding
        let separatorWidth = self.separatorWidth
        
        let distributionLowerBound = contentBounds.minX - padding.left
        let distributionUpperBound = distributionLowerBound + contentBounds.width
        
        if let rows = rows {
            let rowsCount = rows.count
            let rowX = contentBounds.minX
            var rowY = padding.top
            for i in 0..<rowsCount {
                let row = rows[i]
                let rowRect = CGRect(origin: CGPoint(x: rowX, y: rowY), size: CGSize(width: min(row.length, contentBounds.width), height: row.width))
                row.rect = rowRect
                
                if contentBounds.intersects(rowRect) {
                    if let distributionRow = row as? FlowChartViewDistributionRow {
                        if let distributeRow = adapter.distributeRow {
                            let distribution = distributionRow.distribute(distributionLowerBound, distributionUpperBound)
                            distributeRow(self, distribution, i)
                        }
                    }
                    adapter.drawRow?(self, i, context)
                }
                
                rowY = rowRect.maxY
                
                if i < rowsCount - 1 {
                    rowY += separatorWidth
                }
            }
        }
        
        
        adapter.didDraw?(self, context)
        
    }
    
    /// 重新加载数据
    @objc
    public func reloadData() {
        needsReloadData = true
        setNeedsLayout()
    }
    
    /// 如果设置contentSizex小数位不足1px，会丢失精度
    func reviseSize(_ size: CGFloat) -> CGFloat {
        let integer = Int(size)
        var decimal = fmod(size, CGFloat(integer))
        if decimal==0 {
            return size
        }
        
        let px = 1 / UIScreen.main.scale
        if decimal > px {
            decimal = CGFloat(Int(decimal / px)) * px + px // px 补位
        } else {
            decimal = px // 1px
        }
        return CGFloat(integer) + decimal
    }
    
}
