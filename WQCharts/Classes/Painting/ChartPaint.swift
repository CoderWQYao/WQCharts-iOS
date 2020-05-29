//
//  ChartPaint.swift
//  WQCharts
//
//  Created by 姚伟祺 on 2020/5/28.
//  Copyright © 2020 wq.charts. All rights reserved.
//

import UIKit


@objc(WQChartFillPaint)
open class ChartFillPaint: NSObject, ChartAnimatable {
 
    @objc open var color: UIColor?
    
    @objc open var shader: ChartShader?
    
    @objc open var colorTween: ChartUIColorTween?
      
    
    @objc
    public override convenience init() {
        self.init(.clear)
    }

    @objc(initWithColor:)
    public init(_ color: UIColor?) {
        self.color = color
    }
    
    @objc(drawPath:inRect:context:)
    open func draw(_ path: CGPath, _ rect: ChartShaderRect, _ context: CGContext) {
        if path.isEmpty {
            return
        }
        
        context.saveGState()
        context.beginPath()
        context.addPath(path)
        context.setLineWidth(0)
        
        if let shader = self.shader {
            shader.draw(rect, context)
        } else if let color = self.color {
            context.setFillColor(color.cgColor)
            context.fillPath()
        }

        context.restoreGState()
    }
    
     open func transform(_ t: CGFloat) {
        if let colorTween = colorTween {
            color = colorTween.lerp(t)
        }
        
        shader?.transform(t)
    }
    
    open func clearAnimationElements() {
        colorTween = nil
        shader?.clearAnimationElements()
    }
    
}

@objc(WQChartLinePaint)
open class ChartLinePaint: NSObject, ChartAnimatable {

    @objc open var color: UIColor?
    @objc open var width = CGFloat(0)
    @objc open var join = CGLineJoin.miter
    @objc open var cap = CGLineCap.butt
    @objc open var dashPhase = CGFloat(0)
    @objc open var dashLengths: [CGFloat]?
    
    @objc open var widthTween: ChartCGFloatTween?
    @objc open var colorTween: ChartUIColorTween?
    
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
    
    open func transform(_ t: CGFloat) {
        if let widthTween = widthTween {
            width = widthTween.lerp(t)
        }
        
        if let colorTween = colorTween {
            color = colorTween.lerp(t)
        }
        
    }
    
    open func clearAnimationElements() {
        widthTween = nil
        colorTween = nil
    }
    
}


@objc(WQChartShapePaint)
open class ChartShapePaint: NSObject, ChartAnimatable  {
    
    @objc open var fill: ChartFillPaint?
    @objc open var stroke: ChartLinePaint?
    
    @objc
    public override convenience init() {
        self.init(ChartFillPaint(),ChartLinePaint())
    }
    
    @objc(initWithFill:)
    public convenience init(_ fill: ChartFillPaint) {
        self.init(fill, ChartLinePaint())
    }
    
    @objc(initWithStroke:)
    public convenience init(_ stroke: ChartLinePaint) {
        self.init(ChartFillPaint(), stroke)
    }
    
    @objc(initWithFill:stroke:)
    public init(_ fill: ChartFillPaint, _ stroke: ChartLinePaint) {
        self.fill = fill
        self.stroke = stroke
    }
    
    @objc(drawPath:inRect:context:)
    open func draw(_ path: CGPath, _ rect: ChartShaderRect, _ context: CGContext) {
        self.fill?.draw(path, rect, context)
        self.stroke?.draw(path, context)
    }
    
    open func transform(_ t: CGFloat) {
        fill?.transform(t)
        stroke?.transform(t)
    }
    
    open func clearAnimationElements() {
        fill?.clearAnimationElements()
        stroke?.clearAnimationElements()
    }
    
}
