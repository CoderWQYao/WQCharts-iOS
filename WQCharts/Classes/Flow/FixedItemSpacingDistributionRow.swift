// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// FixedItemSpacingDistributionRow.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 固定子项间距分布行
@objc(WQFixedItemSpacingDistributionRow)
open class FixedItemSpacingDistributionRow: FlowChartView.Row, FlowChartViewDistributionRow {

    @objc public let itemSpacing: CGFloat
    @objc public let itemCount: Int
    
    @objc(initWithWidth:itemSpacing:itemCount:)
    public init(_ width: CGFloat, _ itemSpacing: CGFloat, _ itemCount: Int) {
        self.itemSpacing = itemSpacing
        self.itemCount = itemCount
        super.init(width)
    }
    
    override open func measureLength(_ visualRange: CGFloat) -> CGFloat {
        return itemCount > 0 ? CGFloat(itemCount - 1) * itemSpacing : 0
    }
    
    
    public func distribute(_ lowerBound: CGFloat, _ upperBound: CGFloat) -> FlowDistribution {
        let distribution = FlowDistribution()

        let spacing = self.itemSpacing
        let start = lowerBound >= 0 && spacing > 0 ? lowerBound / spacing : 0
        let startInt = Int(ceil(start))
        let startDecimal = fmod(start, 1)
        let capacity = (spacing > 0 ? (upperBound - lowerBound) / spacing : 0) + 1
        let capacityInt = Int(capacity)
        let capacityDecimal = fmod(capacity, 1)

        let items = NSMutableArray(capacity: capacityInt)
        if startDecimal > 0 { // 超出范围的点
            let item = FlowDistributionItem()
            item.index = startInt - 1
            item.location = CGFloat(item.index) * spacing
            items.add(item)
        }
        for i in 0..<capacityInt {
            let item = FlowDistributionItem()
            item.index = i + startInt
            item.location = CGFloat(item.index) * spacing
            items.add(item)
        }
        if capacityDecimal > 0 && capacityInt + startInt < itemCount { // 超出范围的点
            let item = FlowDistributionItem()
            item.index = capacityInt + startInt
            item.location = CGFloat(item.index) * spacing
            items.add(item)
        }

        distribution.items = items as? [FlowDistributionItem]
        distribution.lowerBound = lowerBound
        distribution.upperBound = upperBound
        return distribution
    }
    
    
}
