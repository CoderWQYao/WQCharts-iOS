// 代码地址: 
// LineChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQLineChartView)
open class LineChartView: CoordinateChartView {
   
    @objc private(set) public var chart = LineChart()
    @objc private(set) public var graphic: LineGraphic?
    
    public override func draw(_ rect: CGRect, _ context: CGContext) {
        let graphic = chart.drawGraphic(rect, context)
        chart.drawText(graphic, context)
        self.graphic = graphic
    }
    
}
