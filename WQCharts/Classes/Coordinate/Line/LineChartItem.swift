// https://github.com/CoderWQYao/WQCharts-iOS
//
// LineChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQLineChartItem)
open class LineChartItem: BaseChartItem {
    
    @objc open var value = CGPoint.zero
    @objc open var headerText: ChartText?
    @objc open var footerText: ChartText?
    
    @objc
    public convenience override init() {
        self.init(.zero)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGPoint) {
        super.init()
        
        self.value = value
    }
    
}
