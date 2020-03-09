// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadialGraphic)
open class RadialGraphic: Graphic {

    @objc open var angle = CGFloat(0)
    @objc open var direction: RadialChart.Direction = .Clockwise
    @objc open var rotation = CGFloat(0)

    public override init(_ builder: Chart, _ rect: CGRect) {
        super.init(builder,rect)
        let chart = builder as! RadialChart
        self.angle = chart.angle
        self.direction = chart.direction
        self.rotation = chart.rotation
    }
    
}
