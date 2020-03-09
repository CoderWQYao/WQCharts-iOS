// https://github.com/CoderWQYao/WQCharts-iOS
//
// PolygonChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPolygonChartItem)
open class PolygonChartItem: BaseChartItem {
    
    @objc open var value = CGFloat(0)
    @objc open var text: ChartText?
    
    @objc
    public override convenience init() {
        self.init(0)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGFloat) {
        super.init()
        self.value = value
    }
    
}
