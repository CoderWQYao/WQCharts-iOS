// https://github.com/CoderWQYao/WQCharts-iOS
//
// LinePaint.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQLinePaint)
open class LinePaint: BaseChartItem {

    @objc open var color: UIColor?
    @objc open var width = CGFloat(0)
    @objc open var join = CGLineJoin.miter
    @objc open var cap = CGLineCap.butt
    @objc open var dashPhase = CGFloat(0)
    @objc open var dashLengths: [CGFloat]?
    
    @objc
    public override convenience init() {
        self.init(.black,1)
    }
    
    @objc(initWithColor:)
    public convenience init(_ color: UIColor?) {
        self.init(color,1)
    }
    
    @objc(initWithWidth:)
    public convenience init(_ width: CGFloat) {
        self.init(nil,width)
    }
    
    @objc(initWithColor:width:)
    public init(_ color: UIColor?, _ width: CGFloat) { 
        self.color = color
        self.width = width
    }
    
    @objc(drawPath:inContext:)
    open func draw(_ path: CGPath, _ context: CGContext) {
        if self.width<=0 || path.isEmpty {
            return
        }
        
        guard let color = color else {
            return
        }
        
        context.saveGState()
        context.beginPath()
        context.addPath(path)
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(width)
        context.setLineJoin(join)
        context.setLineCap(cap)
        if let dashLengths = dashLengths {
            context.setLineDash(phase: dashPhase, lengths: dashLengths)
        }
        context.strokePath()
        context.restoreGState()
    }
    
}
