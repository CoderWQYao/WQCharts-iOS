// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialGradientShader.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQRadialGradientShader)
open class RadialGradientShader: NSObject, Shader {
    
    @objc private(set) public var centerPoint: CGPoint
    @objc private(set) public var radius: CGFloat
    @objc private(set) public var colors: [UIColor]
    @objc private(set) public var positions: [CGFloat]?
    @objc private(set) public var options: CGGradientDrawingOptions
    
    @objc(initWithCenterPoint:radius:colors:positions:options:)
    public init(_ centerPoint: CGPoint, _ radius: CGFloat, _ colors: [UIColor], _ positions: [CGFloat]?, _ options: CGGradientDrawingOptions) {
        self.centerPoint = centerPoint
        self.radius = radius
        self.colors = colors
        self.positions = positions
        self.options = options
    }
    
    @objc(initWithCenterPoint:radius:colors:positions:)
    public convenience init(_ centerPoint: CGPoint, _ radius: CGFloat, _ colors: [UIColor], _ positions: [CGFloat]?) {
        self.init(centerPoint,radius,colors,positions,.drawsBeforeStartLocation)
    }
    
    @objc(initWithCenterPoint:radius:colors:)
    public convenience init(_ centerPoint: CGPoint, _ radius: CGFloat, _ colors: [UIColor]) {
        self.init(centerPoint,radius,colors,[0,1])
    }
    
    @objc(drawInContext:)
    public func draw(_ context: CGContext) {
        let colors = NSMutableArray()
        for color in self.colors {
            colors.add(color.cgColor)
        }
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors:colors as CFArray, locations: self.positions) else {
            return
        }
        context.clip()
        context.drawRadialGradient(gradient, startCenter: centerPoint, startRadius: 0, endCenter: centerPoint, endRadius: radius, options: options)
    }
    
    
}
