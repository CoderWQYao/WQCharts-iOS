// 代码地址: 
// ShapePaint.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQShapePaint)
/// 绘制图形的油漆
open class ShapePaint: BaseChartItem {
    
    /// 填充油漆
    @objc open var fill: FillPaint?
    ///
    @objc open var stroke: LinePaint?
    
    @objc
    public override convenience init() {
        self.init(FillPaint(),LinePaint())
    }
    
    @objc(initWithFill:)
    public convenience init(_ fill: FillPaint) {
        self.init(fill, LinePaint())
    }
    
    @objc(initWithStroke:)
    public convenience init(_ stroke: LinePaint) {
        self.init(FillPaint(), stroke)
    }
    
    @objc(initWithFill:stroke:)
    public init(_ fill: FillPaint, _ stroke: LinePaint) {
        self.fill = fill
        self.stroke = stroke
    }
    
    @objc(drawPath:inContext:object:)
    open func draw(_ path: CGPath, _ context: CGContext, _ object: Any?) {

        if let fillPaint = self.fill {
            fillPaint.draw(path, context, object)
        }
        
        if let strokePaint = self.stroke {
            strokePaint.draw(path, context)
        }
        
    }
}
