// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarChartPolygon.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadarChartPolygon)
open class RadarChartPolygon: ChartItem {
    
    @objc open var chart: PolygonChart
    @objc open var needsReloadItems = false
    
    @objc(initWithChart:)
    public init(_ chart: PolygonChart) {
        self.chart = chart
        self.needsReloadItems = true
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
