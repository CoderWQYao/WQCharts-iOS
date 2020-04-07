// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarChartIndicator.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadarChartIndicator)
open class RadarChartIndicator: ChartItem {
    
    @objc open var text: ChartText?
    @objc open var paint: LinePaint?
    
    @objc
    public override init() {
        super.init()
        self.paint = LinePaint()
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        paint?.nextTransform(progress)
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        paint?.clearTransforms()
    }
    
}
