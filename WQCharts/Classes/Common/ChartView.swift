// https://github.com/CoderWQYao/WQCharts-iOS
//
// ChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQChartView)
open class ChartView: UIView {
    
    //         Top
    //      ┌────────┐
    //      │        │
    // Left │  Rect  │ Right
    //      │        │
    //      └────────┘
    //        Bottom
    @objc
    open var padding = UIEdgeInsets.zero {
        didSet {
            redraw()
        }
    }
    
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
    
    @objc
    open var onDrawBefore: ((_ chartsView: ChartView, _ context: CGContext, _ rect: CGRect) -> Void)?
    
    @objc
    open var onDrawAfter: ((_ chartsView: ChartView, _ context: CGContext, _ rect: CGRect) -> Void)?
    
    open override func layoutSubviews() {
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
        
        if let onDrawBefore = onDrawBefore {
            onDrawBefore(self, context, rect)
        }
        
        draw(rect, context)
        
        if let onDrawAfter = onDrawAfter {
            onDrawAfter(self, context, rect)
        }
    }
    
    
    @objc(drawRect:inContext:)
    public func draw(_ rect: CGRect, _ context: CGContext) {
        
    }
    
    public override var description: String {
        get {
            return String(format: "<%@: %p frame = %@ padding = %@>",arguments:[NSStringFromClass(type(of:self)),self,NSCoder.string(for: self.frame),NSCoder.string(for: self.padding)])
        }
    }
    
    @objc
    public func redraw() {
        setNeedsDisplay()
    }
    
}
