// 代码地址: 
// PolygonChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 表示多边形中的点
@objc(WQPolygonChartItem)
open class PolygonChartItem: BaseChartItem {
    
    /// 用于计算点的位置，值越大，离中心越远
    @objc open var value = CGFloat(0)
    /// 绘制在点上的文本
    @objc open var text: ChartText?
    
    @objc
    public override convenience init() {
        self.init(0)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGFloat) {
        super.init()
        self.value = value
    }
    
}
