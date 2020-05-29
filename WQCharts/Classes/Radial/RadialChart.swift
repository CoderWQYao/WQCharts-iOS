// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialChart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 表示一个从中心点以放射状扩散的图表抽象
@objc(WQRadialChart)
open class RadialChart: NSObject, Chart, ChartAnimatable {

    @objc(WQPieChartDirection)
    public enum Direction: Int {
        case Clockwise
        case CounterClockwise
    }
    
    @objc open var angle = CGFloat(360)
    @objc open var rotation = CGFloat(0)
    @objc open var direction = Direction.Clockwise
  
    @objc open var angleTween: ChartCGFloatTween?
    @objc open var rotationTween: ChartCGFloatTween?
    
    open func draw(inRect rect: CGRect, context: CGContext) {
        fatalError("draw(inRect:,context:) has not been implemented")
    }
    
    open func transform(_ t: CGFloat) {
        if let angleTween = angleTween {
            self.angle = angleTween.lerp(t)
        }
        
        if let rotationTween = rotationTween {
            self.rotation = rotationTween.lerp(t)
        }
    }

    open func clearAnimationElements() {
        
        angleTween = nil;
        rotationTween = nil;
    }
    
}
