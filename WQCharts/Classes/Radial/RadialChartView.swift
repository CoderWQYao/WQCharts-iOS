// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadialChartViewRotationDelegate)
public protocol RadialChartViewRotationDelegate {
    
    @objc optional func radialChartView(_ radialChartView: RadialChartView, rotationDidChange rotation: CGFloat, translation: CGFloat)
     
}

@objc(WQRadialChartView)
open class RadialChartView: ChartView {
    
    @objc open var chartAsRadial: RadialChart {
        fatalError("chartAsRadial has not been implemented")
    }

    @objc open var graphicAsRadial: RadialGraphic? {
        fatalError("graphicAsRadial has not been implemented")
    }
    
    @objc open weak var rotationDelegate: RadialChartViewRotationDelegate?
    
    private var lastTouchAngle: CGFloat?
    
    override func prepare() {
        super.prepare()
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }

    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let center = CGPoint(x: bounds.midX,y: bounds.midY)
        let radian = atan2((touchLocation.y - center.y),(touchLocation.x - center.x))
        let touchAngle = ChartMath.rad2deg(radian)
        if gestureRecognizer.state == .changed, let lastTouchAngle = lastTouchAngle {
            if touchAngle != lastTouchAngle {
                let rotationOffset = touchAngle - lastTouchAngle
                let chart = chartAsRadial
                chart.rotation = ChartMath.angleIn360Degree(chart.rotation + rotationOffset)
                rotationDelegate?.radialChartView?(self, rotationDidChange: chart.rotation, translation: rotationOffset)
                redraw()
            }
        }
        lastTouchAngle = touchAngle
    }
    
}
