// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// FixedVisiableCountDistributionRow.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit


/// 固定显示数分布行，每个子项的间距是根据边界和显示数计算的
@objc(WQFixedVisiableCountDistributionRow)
open class FixedVisiableCountDistributionRow: FlowChartView.Row, FlowChartViewDistributionRow {

    @objc public let visiableCount: Int
    @objc public let itemCount: Int
    
    @objc(initWithWidth:visiableCount:itemCount:)
    public init(_ width: CGFloat, _ visiableCount: Int, _ itemCount: Int) {
        self.visiableCount = visiableCount
        self.itemCount = itemCount
        super.init(width)
    }
    
    override open func measureLength(_ visualRange: CGFloat) -> CGFloat {
        let itemSpacing = visiableCount > 1 ? visualRange / CGFloat(visiableCount - 1) : 0
        return itemCount > 0 ? CGFloat(itemCount - 1) * itemSpacing : 0
    }
    
    public func distribute(_ lowerBound: CGFloat, _ upperBound: CGFloat) -> FlowDistribution {
        let distribution = FlowDistribution()
        
        let visiableCount = self.visiableCount
        let itemSpacing = visiableCount > 1 ? (upperBound - lowerBound) / CGFloat(visiableCount - 1) : 0
        let start = Int(round(itemSpacing > 0 ? lowerBound / itemSpacing : 0))
        let items = NSMutableArray(capacity: visiableCount)
        
        for i in 0..<visiableCount {
            let item = FlowDistributionItem()
            item.index = i + start
            item.location = CGFloat(item.index) * itemSpacing
            items.add(item)
        }
        
        distribution.items = items as? [FlowDistributionItem]
        distribution.lowerBound = lowerBound
        distribution.upperBound = upperBound
        return distribution
    }
    
}
