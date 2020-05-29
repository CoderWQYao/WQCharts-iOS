// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadarChartView)
open class RadarChartView: RadialChartView {
    
    @objc private(set) public var chart = RadarChart()
    /// The last drew Graphic for Radar in View
    @objc private(set) public var graphic: RadarGraphic?
    
    override open var chartAsRadial: RadialChart {
        return chart
    }
    
    override open var graphicAsRadial: RadialGraphic? {
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
