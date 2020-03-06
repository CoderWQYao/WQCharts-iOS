// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// AxisChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQAxisChartItem)
open class AxisChartItem: BaseChartItem {

    @objc open var start = CGPoint.zero
    @objc open var end = CGPoint.zero
    @objc open var paint: LinePaint?
    @objc open var headerText: ChartText?
    @objc open var footerText: ChartText?
    
    @objc
    public convenience override init() {
        self.init(.zero,.zero)
    }

    @objc(initWithStart:end:)
    public init(_ start: CGPoint,  _ end: CGPoint) {
        super.init()

        self.start = start
        self.end = end
        self.paint = LinePaint()
    }
    
}
