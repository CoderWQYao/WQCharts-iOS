// https://github.com/CoderWQYao/WQCharts-iOS
//
// ShapePaint.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQShapePaint)
open class ShapePaint: ChartItem  {
    
    @objc open var fill: FillPaint?
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

        self.fill?.draw(path, context, object)
        self.stroke?.draw(path, context)
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        fill?.nextTransform(progress)
        stroke?.nextTransform(progress)
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        fill?.clearTransforms()
        stroke?.clearTransforms()
    }
    
}
