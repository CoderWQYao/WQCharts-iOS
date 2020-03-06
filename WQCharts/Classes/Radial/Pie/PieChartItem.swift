// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// PieChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 表示饼图中的扇形
@objc(WQPieChartItem)
open class PieChartItem: BaseChartItem {
    
    /// 用于计算弧度值，值越大弧度越大。默认0。
    @objc open var value = CGFloat(0)
    /// 相对于弧心的偏移倍率。默认0
    @objc open var offsetFactor = CGFloat(0)
    /// 内弧倍率。默认0
    @objc open var innerFactor = CGFloat(0)
    /// 外弧倍率。默认1
    @objc open var outerFactor = CGFloat(0)
    /// 描绘扇形的油漆
    @objc open var paint: ShapePaint?
    /// 扇形中的文本
    @objc open var text: ChartText?
    
    @objc
    public override convenience init() {
        self.init(0)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGFloat) {
        super.init()
        self.value = value
        self.paint = ShapePaint()
        self.innerFactor = 0
        self.outerFactor = 1
    }
    
    /// 返回总Value值
    /// - parameter items: 需要计算的Items
    @objc(totalValueWithItems:)
    open class func getTotalValue(_ items: [PieChartItem]?) -> CGFloat {
        var totalValue = CGFloat(0)
        guard let items = items else {
            return totalValue
        }
        
        for item in items {
            totalValue += item.value
        }
        return totalValue
    }
    
}
