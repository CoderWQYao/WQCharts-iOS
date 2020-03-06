// 代码地址: 
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
/// 填充油漆
open class FillPaint: BaseChartItem {
 
    /// 颜色
    @objc open var color: UIColor?
    
    /// 着色器
    @objc open var shader: ((_ paint: FillPaint, _ path: CGPath, _ object: Any?) -> Shader?)?
    
    @objc
    public override convenience init() {
        self.init(.clear)
    }

    @objc(initWithColor:)
    public init(_ color: UIColor?) {
        self.color = color
    }
    
    @objc(drawPath:inContext:object:)
    /// 填充绘制
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
}
