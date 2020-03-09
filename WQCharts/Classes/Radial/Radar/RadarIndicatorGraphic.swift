// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarIndicatorGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadarIndicatorGraphic)
open class RadarIndicatorGraphic: GraphicItem {
    
    @objc open var angle = CGFloat(0)
    @objc open var startPoint = CGPoint.zero
    @objc open var endPoint = CGPoint.zero
    @objc open var path: CGPath?
    
}
