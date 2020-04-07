// https://github.com/CoderWQYao/WQCharts-iOS
//
// PolygonGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPolygonGraphic)
open class PolygonGraphic: RadialGraphic {
    
    @objc public var pathRadius = CGFloat(0)
    @objc public var path: CGPath?
    @objc public var items: [PolygonGraphicItem]?
    
}
