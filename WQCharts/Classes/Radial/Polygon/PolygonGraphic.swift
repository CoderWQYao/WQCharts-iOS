// 代码地址: 
// PolygonGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPolygonGraphic)
open class PolygonGraphic: RadialGraphic {
    
    @objc public var shapeRadius = CGFloat(0)
    @objc public var shapePath: CGPath?
    @objc public var axisPath: CGPath?
    @objc public var items: [PolygonGraphicItem]?
    
}
