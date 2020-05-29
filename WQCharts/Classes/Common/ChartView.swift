// https://github.com/CoderWQYao/WQCharts-iOS
//
// ChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQChartViewDrawDelegate)
public protocol ChartViewDrawDelegate {
    
    @objc func chartViewWillDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext)
    @objc func chartViewDidDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext)
    
}

@objc(WQChartView)
open class ChartView: UIView, ChartAnimatable  {
    
    //         Top
    //      ┌────────┐
    //      │        │
    // Left │  Rect  │ Right
    //      │        │
    //      └────────┘
    //        Bottom
    @objc open var padding: UIEdgeInsets = .zero {
        didSet {
            redraw()
        }
    }
    
    @objc open var clipRect: NSValue? {
        didSet {
            redraw()
        }
    }
    
    @objc open var paddingTween: ChartUIEdgeInsetsTween?
    @objc open var clipRectTween: ChartCGRectTween?
    
    @objc open weak var drawDelegate: ChartViewDrawDelegate?
    
    private var layoutSize = CGSize.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        prepare()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    func prepare() {
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if !layoutSize.equalTo(bounds.size) {
            layoutSize = bounds.size
            redraw()
        }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let rect = bounds.inset(by: self.padding)
        drawDelegate?.chartViewWillDraw(self, inRect: rect, context: context)
        if let clipRect = clipRect {
            context.clip(to: clipRect.cgRectValue)
        }
        draw(rect, context)
        if clipRect != nil {
            context.resetClip()
        }
        drawDelegate?.chartViewDidDraw(self, inRect: rect, context: context)
    }
    
    
    @objc(drawRect:inContext:)
    open func draw(_ rect: CGRect, _ context: CGContext) {
        
    }
    
    override open var description: String {
        get {
            return String(format: "<%@: %p frame = %@ padding = %@>",arguments:[NSStringFromClass(type(of:self)),self,NSCoder.string(for: self.frame),NSCoder.string(for: self.padding)])
        }
    }
    
    @objc
    open func redraw() {
        setNeedsDisplay()
    }
    
    open func transform(_ t: CGFloat) {
        if let paddingTween = paddingTween {
            padding = paddingTween.lerp(t)
        }
        
        if let clipRectTween = clipRectTween {
            clipRect = clipRectTween.lerp(t) as NSValue
        }
    }
    
    open func clearAnimationElements() {
        paddingTween = nil
        clipRectTween = nil
    }
    
}
