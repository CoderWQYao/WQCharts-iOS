// 代码地址: 
// RadarChartIndicator.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadarChartIndicator)
open class RadarChartIndicator: BaseChartItem {
    
    @objc open var text: ChartText?
    @objc open var paint: LinePaint?
    
    @objc
    public override init() {
        super.init()
        self.paint = LinePaint()
    }

}
