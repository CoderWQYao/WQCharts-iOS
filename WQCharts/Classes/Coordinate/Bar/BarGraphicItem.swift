// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// BarGraphicItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQBarGraphicItem)
open class BarGraphicItem: GraphicItem {

    @objc open var rect = CGRect.zero
    @objc open var stringStart = CGPoint.zero
    @objc open var stringEnd = CGPoint.zero
    @objc open var angleReversed = false
    @objc open var stringAngle = CGFloat(0)
    @objc open var path: CGPath?
    
}
