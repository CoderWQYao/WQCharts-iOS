// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadialChart)
open class RadialChart: NSObject, Chart {
    
    @objc(WQPieChartDirection)
    public enum Direction: Int {
        case Clockwise
        case CounterClockwise
    }
    
    @objc open var angle = CGFloat(360)
    @objc open var direction: Direction = .Clockwise
    @objc open var rotation = CGFloat(0)
  
    open func draw(_ rect: CGRect, _ context: CGContext) {
        fatalError("draw(CGRect,CGContext) has not been implemented")
    }

}
