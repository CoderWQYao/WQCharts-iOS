// https://github.com/CoderWQYao/WQCharts-iOS
//
// BarChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQBarChartView)
open class BarChartView: CoordinateChartView {

    @objc private(set) public var chart = BarChart()
    /// The last drew Graphic for Bar in View
    @objc private(set) public var graphic: BarGraphic?
    
    override open var chartAsCoordinate: CoordinateChart {
        return chart
    }

    override open var graphicAsCoordinate: CoordinateGraphic? {
        return graphic
    }
    
    public override func draw(_ rect: CGRect, _ context: CGContext) {
        let graphic = chart.drawGraphic(rect, context)
        chart.drawText(graphic, context)
        self.graphic = graphic
    }

    override open func transform(_ t: CGFloat) {
        super.transform(t)
        chart.transform(t)
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        chart.clearAnimationElements()
    }
    
}
