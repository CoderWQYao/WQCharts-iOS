// 代码地址: 
// RadarGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadarGraphic)
open class RadarGraphic: RadialGraphic {
    
    @objc open var indicators: [RadarIndicatorGraphic]?
    @objc open var segments: [RadarSegmentGraphic]?
    @objc open var polygons: [PolygonGraphic]?
    
}
