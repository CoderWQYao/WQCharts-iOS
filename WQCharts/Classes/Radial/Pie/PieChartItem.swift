// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPieChartItem)
open class PieChartItem: BaseChartItem {
    
    @objc open var value = CGFloat(0)
    @objc open var offsetFactor = CGFloat(0)
    @objc open var innerFactor = CGFloat(0)
    @objc open var outerFactor = CGFloat(0)
    @objc open var paint: ShapePaint?
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
