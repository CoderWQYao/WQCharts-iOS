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
    @objc open var paint: ChartLinePaint?
    
    @objc
    public override init() {
        super.init()
        self.paint = ChartLinePaint()
    }
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        
        paint?.transform(t)
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        
        paint?.clearAnimationElements()
    }
    
}
