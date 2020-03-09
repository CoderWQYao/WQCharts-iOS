// https://github.com/CoderWQYao/WQCharts-iOS
//
// BizChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQBizChartViewAdapter)
public protocol BizChartViewAdapter {
    
    @objc(numberOfRowsInHorizontalBizChartView:)
    func getRowCount(_ BizChartView: BizChartView) -> Int
    
    @objc(BizChartView:rowAtIndex:)
    func getRow(_ BizChartView: BizChartView, _ index: Int) -> BizChartView.Row

    @objc(BizChartView:distributionForRow:atIndex:)
    optional func distributeRow(_ BizChartView: BizChartView, _ distribution: BizDistribution, _ index: Int)
    
    @objc(BizChartView:drawRowAtIndex:inContext:)
    optional func drawRow(_ BizChartView: BizChartView, _ index: Int, _ context: CGContext)

    @objc(BizChartViewWillDraw:inContext:)
    optional func willDraw(_ BizChartView: BizChartView, _ context: CGContext)
    
    @objc(BizChartViewDidDraw:inContext:)
    optional func didDraw(_ BizChartView: BizChartView, _ context: CGContext)
      
}

@objc(WQBizChartViewDistributionRow)
public protocol BizChartViewDistributionRow {
   
    @objc func distribute(_ lowerBound: CGFloat, _ upperBound: CGFloat) -> BizDistribution
    
}

@objc(WQBizChartView)
open class BizChartView: ScrollChartView {
    

    @objc(WQBizChartViewRow)
    open class Row: NSObject {
        
        @objc public let width: CGFloat
        @objc internal(set) public var length = CGFloat(0)
        @objc internal(set) public var rect = CGRect.zero
        
        @objc(initWithWidth:)
        public init(_ width: CGFloat) {
            self.width = width
            super.init()
        }
        
        @objc(measureLengthWithVisualRange:)
        open func measureLength(_ visualRange: CGFloat) -> CGFloat {
            return visualRange
        }
    
    }
    
    override func prepare() {
        super.prepare()
        
        isDirectionalLockEnabled = true
    }
    
    @objc open var padding = UIEdgeInsets.zero {
         didSet {
             reloadData()
         }
    }
    
    @objc open weak var adapter: BizChartViewAdapter? {
        didSet {
            reloadData()
        }
    }
    
    @objc open var separatorWidth = CGFloat(0) {
        didSet {
            redraw()
        }
    }
    
    @objc open private(set) var rows: [Row]?
    
    private var needsReloadData = false
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
                    if let distributionRow = row as? BizChartViewDistributionRow {
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
