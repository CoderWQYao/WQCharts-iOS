// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadialChartView)
open class RadialChartView: ChartView {
    
    private var lastTouchAngle: CGFloat?
    @objc open var onRotationChange: ((_ chartView: RadialChartView,  _ rotation: CGFloat, _ translation: CGFloat) -> Void)?
    
    override func prepare() {
        super.prepare()
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let center = CGPoint(x: bounds.midX,y: bounds.midY)
        let radian = atan2((touchLocation.y - center.y),(touchLocation.x - center.x))
        let touchAngle = Helper.convertRadianToAngle(radian)
        if gestureRecognizer.state == .changed, let lastTouchAngle = lastTouchAngle {
            if touchAngle != lastTouchAngle {
                let rotationOffset = touchAngle - lastTouchAngle
                callRotationOffset(rotationOffset)
            }
        }
        lastTouchAngle = touchAngle
    }
    
    open func callRotationOffset(_ rotationOffset: CGFloat) {
        
    }
    
}
