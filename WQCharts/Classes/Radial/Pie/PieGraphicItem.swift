// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieGraphicItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPieGraphicItem)
open class PieGraphicItem: GraphicItem {
    
    @objc internal(set) public var center: CGPoint = CGPoint()
    @objc internal(set) public var arc2Radius = CGFloat(0)
    @objc internal(set) public var arc1Radius = CGFloat(0)
    @objc internal(set) public var startAngle = CGFloat(0)
    @objc internal(set) public var sweepAngle = CGFloat(0)
    @objc internal(set) public var path: CGPath?
    
}
