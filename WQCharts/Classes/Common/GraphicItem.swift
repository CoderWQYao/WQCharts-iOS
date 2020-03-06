// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// GraphicItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQGraphicItem)
open class GraphicItem: NSObject {
    
    @objc public let builder: BaseChartItem
    
    @objc(initWithBuilder:)
    public init(_ builder: BaseChartItem) {
        self.builder = builder
        super.init()
    }
    
}
