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
    
    public override func draw(_ rect: CGRect, _ context: CGContext) {
        let graphic = chart.drawGraphic(rect, context)
        chart.drawText(graphic, context)
        self.graphic = graphic
    }
    
    open override func callRotationOffset(_ rotationOffset: CGFloat) {
        chart.rotation = Helper.angleIn360Degree(chart.rotation + rotationOffset)
        redraw()
        onRotationChange?(self,chart.rotation,rotationOffset)
    }
    
}
