// 代码地址: 
// RadialChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 表示放射状图表
@objc(WQRadialChart)
open class RadialChart: NSObject, Chart {
    
    /// 方向
    @objc(WQPieChartDirection)
    public enum Direction: Int {
        /// 顺时针方向
        case Clockwise
        /// 逆时针方向
        case CounterClockwise
    }
    
    /// 绘制角度
    @objc open var angle = CGFloat(360)
    
    /// 绘制方向
    @objc open var direction: Direction = .Clockwise
    
    /// 旋转角度
    @objc open var rotation = CGFloat(0)
  
    open func draw(_ rect: CGRect, _ context: CGContext) {
        fatalError("draw(CGRect,CGContext) has not been implemented")
    }

}
