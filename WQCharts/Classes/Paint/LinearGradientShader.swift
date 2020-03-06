// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// LinearGradientShader.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQLinearGradientShader)
open class LinearGradientShader: NSObject, Shader {
    
    @objc private(set) public var startPoint: CGPoint
    @objc private(set) public var endPoint: CGPoint
    @objc private(set) public var colors: [UIColor]
    @objc private(set) public var positions: [CGFloat]?
    @objc private(set) public var options: CGGradientDrawingOptions
    
    /**
     * Create a shader that draws a linear gradient along a line.
     *
     * @param startPoint    The point for the start of the gradient line
     * @param endPoint      The point for the end of the gradient line
     * @param colors        The colors to be distributed along the gradient line
     * @param positions     May be null. The relative positions [0..1] of each corresponding color in the colors array. If this is null, the the colors are distributed evenly along the gradient line.
     * @param options       The Shader options mode
     */
    @objc(initWithStartPoint:endPoint:colors:positions:options:)
    public init(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [UIColor], _ positions: [CGFloat]?, _ options: CGGradientDrawingOptions) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.colors = colors
        self.positions = positions
        self.options = options
    }
    
    @objc(initWithStartPoint:endPoint:colors:positions:)
    public convenience init(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [UIColor], _ positions: [CGFloat]?) {
        self.init(startPoint,endPoint,colors,positions,.drawsBeforeStartLocation)
    }
    
    @objc(initWithStartPoint:endPoint:colors:)
    public convenience init(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [UIColor]) {
        self.init(startPoint,endPoint,colors,[0,1])
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
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: options)
        context.resetClip()
    }
    
}
