//
//  Shader.swift
//  WQCharts
//
//  Created by 姚伟祺 on 2020/5/27.
//  Copyright © 2020 wq.charts. All rights reserved.
//

import UIKit

@objc(WQChartShaderRect)
open class ChartShaderRect: NSObject {
    
    @objc public let min: CGRect
    @objc public let max: CGRect
    
    @objc(initWithMin:max:)
    public init(_ min: CGRect, _ max: CGRect) {
        self.min = min
        self.max = max
    }
    
}

@objc(WQChartShader)
open class ChartShader: NSObject, ChartAnimatable {
    
    @objc(WQChartShading)
    public enum ChartShadedRange: Int {
        case Min,Max
    }
    
    @objc public var shadedRange: ChartShadedRange = .Min
    
    @objc(drawRect:inContext:)
    func draw( _ rect: ChartShaderRect, _ context: CGContext) {
        
    }
    
    open func transform(_ t: CGFloat) {
        
    }
    
    open func clearAnimationElements() {
        
    }
}

@objc(WQChartGradient)
open class ChartGradient: ChartShader {

    /// The colors to be distributed along the gradient line
    @objc public var colors: [UIColor]
    /// May be null. The relative positions [0..1] of each corresponding color in the colors array. If this is null, the colors are distributed evenly along the gradient line.
    @objc public var positions: [CGFloat]?
    /// The Shader options mode
    @objc public var options: CGGradientDrawingOptions = .drawsBeforeStartLocation
    
    @objc public var colorsTween: ChartUIColorArrayTween?
    @objc public var positionsTween: ChartCGFloatArrayTween?
    
    @objc(initWithColors:)
    public init(_ colors: [UIColor]) {
        self.colors = colors
        super.init()
    }
    
    open override func transform(_ t: CGFloat) {
        super.transform(t)
        
        if let colorsTween = self.colorsTween {
            colors = colorsTween.lerp(t)
        }
        
        if let positionsTween = self.positionsTween {
            positions = positionsTween.lerp(t)
        }
    }
     
    open override func clearAnimationElements() {
        super.clearAnimationElements()
        
        colorsTween = nil
        positionsTween = nil
    }
    
}

@objc(WQChartLinearGradient)
open class ChartLinearGradient: ChartGradient {
    
    /// The relative point [0..1] for the start of the gradient line
    @objc public var start: CGPoint
    /// The relative point [0..1] for the end of the gradient line
    @objc public var end: CGPoint
    
    @objc public init(start: CGPoint, end: CGPoint, colors: [UIColor]) {
        self.start = start
        self.end = end
        super.init(colors);
    }
    
    public override func draw( _ rect: ChartShaderRect, _ context: CGContext) {
        let colors = NSMutableArray()
        for color in self.colors {
            colors.add(color.cgColor)
        }
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors:colors as CFArray, locations: positions) else {
            return
        }
        
        let shadedRect = shadedRange == .Max ? rect.max : rect.min
        let shadedStart = CGPoint(x: shadedRect.minX + start.x * shadedRect.width, y: shadedRect.minY + start.y * shadedRect.height)
        let shadedEnd = CGPoint(x: shadedRect.minX + end.x * shadedRect.width, y: shadedRect.minY + end.y * shadedRect.height)
        context.clip()
        context.drawLinearGradient(gradient, start: shadedStart, end: shadedEnd, options: options)
        context.resetClip()
    }
    
}



@objc(WQChartRadialGradient)
open class ChartRadialGradient: ChartGradient {
    
    @objc public var center: CGPoint
    @objc public var radius: CGFloat
    
    @objc public init(center: CGPoint, radius: CGFloat, colors: [UIColor]) {
        self.center = center
        self.radius = radius
        super.init(colors);
    }
    
    public override func draw(_ rect: ChartShaderRect, _ context: CGContext) {
        let colors = NSMutableArray()
        for color in self.colors {
            colors.add(color.cgColor)
        }
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors:colors as CFArray, locations: self.positions) else {
            return
        }
        
        let shadedRect = shadedRange == .Max ? rect.max : rect.min
        let shadedCenter = CGPoint(x: shadedRect.minX + center.x * shadedRect.width, y: shadedRect.minY + center.y * shadedRect.height);
        let shadedRadius = max(shadedRect.width, shadedRect.height) / 2 * radius
        context.clip()
        context.drawRadialGradient(gradient, startCenter: shadedCenter, startRadius: 0, endCenter: shadedCenter, endRadius: shadedRadius, options: options)
    }
    
}
