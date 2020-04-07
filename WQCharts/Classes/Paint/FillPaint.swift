// https://github.com/CoderWQYao/WQCharts-iOS
//
// FillPaint.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc
public protocol Shader {
    
    @objc(drawInContext:)
    func draw(_ context: CGContext)
    
}

@objc(WQFillPaint)
open class FillPaint: ChartItem {
 
    @objc open var color: UIColor?
    
    @objc open var shader: ((_ paint: FillPaint, _ path: CGPath, _ object: Any?) -> Shader?)?
    
    @objc open var transformColor: TransformUIColor?
      
    
    @objc
    public override convenience init() {
        self.init(.clear)
    }

    @objc(initWithColor:)
    public init(_ color: UIColor?) {
        self.color = color
    }
    
    @objc(drawPath:inContext:object:)
    open func draw(_ path: CGPath, _ context: CGContext, _ object: Any?) {
        if path.isEmpty {
            return
        }
        
        context.saveGState()
        context.beginPath()
        context.addPath(path)
        context.setLineWidth(0)
        
        if let shaderCallback = self.shader {
            if let shader = shaderCallback(self, path, object) {
                shader.draw(context)
            }
        } else if let color = self.color {
            context.setFillColor(color.cgColor)
            context.fillPath()
        }

        context.restoreGState()
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        if let transformColor = transformColor {
            color = transformColor.valueForProgress(progress)
        }
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        transformColor = nil
    }
}
