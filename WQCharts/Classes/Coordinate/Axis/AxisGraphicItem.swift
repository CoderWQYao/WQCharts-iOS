// https://github.com/CoderWQYao/WQCharts-iOS
//
// AxisGraphicItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQAxisGraphicItem)
open class AxisGraphicItem: GraphicItem {
    
    @objc open var startPoint = CGPoint.zero
    @objc open var endPoint = CGPoint.zero
    @objc open var path: CGPath?
    
}
