// https://github.com/CoderWQYao/WQCharts-iOS
//
// AreaChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit


@objc(WQAreaChartView)
open class AreaChartView: CoordinateChartView {
    
    
    @objc private(set) public var chart = AreaChart()
    /// The last drew Graphic for Line in View
    @objc private(set) public var graphic: AreaGraphic?
    
    override open var chartAsCoordinate: CoordinateChart {
        return chart
    }
    
    override open var graphicAsCoordinate: CoordinateGraphic? {
        return graphic
    }
    
    public override func draw(_ rect: CGRect, _ context: CGContext) {
        let graphic = chart.drawGraphic(rect, context)
        AreaChart.drawText(graphic, context)
        self.graphic = graphic
    }

    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        chart.nextTransform(progress)
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        chart.clearTransforms()
    }
}
