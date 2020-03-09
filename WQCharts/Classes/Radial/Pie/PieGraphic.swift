// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPieGraphic)
open class PieGraphic: RadialGraphic {

    @objc open var totalValue = CGFloat(0)
    @objc open var items: [PieGraphicItem]?
    
}
