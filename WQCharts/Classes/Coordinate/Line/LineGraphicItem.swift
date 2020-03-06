// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// LineGraphicItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQLineGraphicItem)
open class LineGraphicItem: GraphicItem {
    
    @objc open var shapeStartPoint = CGPoint.zero
    @objc open var shapeEndPoint = CGPoint.zero
    @objc open var linePoint = CGPoint.zero
    
}
