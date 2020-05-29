//
//  ChartTween.swift
//  WQCharts
//
//  Created by 姚伟祺 on 2020/5/28.
//  Copyright © 2020 wq.charts. All rights reserved.
//

import UIKit

@objc(WQChartCGFloatTween)
open class ChartCGFloatTween: NSObject {
    
    @objc public private(set) var from: CGFloat
    @objc public private(set) var to: CGFloat
    
    @objc(initWithFrom:to:)
    public init(_ from: CGFloat, _ to: CGFloat) {
        self.from = from
        self.to = to
        super.init()
    }
    
    func lerp(_ t: CGFloat) -> CGFloat {
        return (to - from) * t + from
    }
    
}


@objc(WQChartDoubleTween)
open class ChartDoubleTween: NSObject {
    
    @objc public private(set) var from: Double
    @objc public private(set) var to: Double
    
    @objc(initWithFrom:to:)
    public init(_ from: Double, _ to: Double) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: Double) -> Double {
        return (to - from) * t + from
    }
    
}

@objc(WQChartFloatTween)
open class ChartFloatTween: NSObject {

    @objc public private(set) var from: Float
    @objc public private(set) var to: Float
    
    @objc(initWithFrom:to:)
    public init(_ from: Float, _ to: Float) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: Float) -> Float {
        return (to - from) * t + from
    }
    
}

@objc(WQChartTweenInt)
open class ChartTweenInt: NSObject {

    @objc public private(set) var from: Int
    @objc public private(set) var to: Int
    
    @objc(initWithFrom:to:)
    public init(_ from: Int, _ to: Int) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: Float) -> Int {
        return Int(roundf(Float(to - from) * t)) + from
    }
    
}

@objc(WQChartCGPointTween)
open class ChartCGPointTween: NSObject {
    
    @objc public private(set) var from: CGPoint
    @objc public private(set) var to: CGPoint
    
    @objc(initWithFrom:to:)
    public init(_ from: CGPoint, _ to: CGPoint) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: CGFloat) -> CGPoint {
        return CGPoint(
            x: (to.x - from.x) * t + from.x,
            y: (to.y - from.y) * t + from.y
        )
    }
    
}


@objc(WQChartCGRectTween)
open class ChartCGRectTween: NSObject {
    
    @objc public private(set) var from: CGRect
    @objc public private(set) var to: CGRect
    
    @objc(initWithFrom:to:)
    public init(_ from: CGRect, _ to: CGRect) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: CGFloat) -> CGRect {
        return CGRect(
            x: (to.minX - from.minX) * t + from.minX,
            y: (to.minY - from.minY) * t + from.minY,
            width: (to.width - from.width) * t + from.width,
            height: (to.height - from.height) * t + from.height
        )
    }
    
}

@objc(WQChartUIColorTween)
open class ChartUIColorTween: NSObject {

    @objc public private(set) var from: UIColor
    @objc public private(set) var to: UIColor
    
    @objc(initWithFrom:to:)
    public init(_ from: UIColor, _ to: UIColor) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: CGFloat) -> UIColor {
        var fromR = CGFloat(0), fromG = CGFloat(0), fromB = CGFloat(0), fromA = CGFloat(0)
        from.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
        
        var toR = CGFloat(0), toG = CGFloat(0), toB = CGFloat(0), toA = CGFloat(0)
        to.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        
        return UIColor(red: (toR - fromR) * t + fromR, green: (toG - fromG) * t + fromG, blue: (toB - fromB) * t + fromB, alpha: (toA - fromA) * t + fromA)
    }
    
}

@objc(WQChartUIEdgeInsetsTween)
open class ChartUIEdgeInsetsTween: NSObject {
    
    @objc public private(set) var from: UIEdgeInsets
    @objc public private(set) var to: UIEdgeInsets
    
    @objc(initWithFrom:to:)
    public init(_ from: UIEdgeInsets, _ to: UIEdgeInsets) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: (to.top - from.top) * t + from.top,
        left: (to.left - from.left) * t + from.left,
        bottom: (to.bottom - from.bottom) * t + from.bottom,
        right: (to.right - from.right) * t + from.right)
    }
    
}

@objc(WQChartUIColorArrayTween)
open class ChartUIColorArrayTween: NSObject {
    
    @objc public private(set) var from: [UIColor]
    @objc public private(set) var to: [UIColor]
    
    @objc(initWithFrom:to:)
    public init(_ from: [UIColor], _ to: [UIColor]) {
        assert(from.count == to.count, "from and to arrays must be of equal length")
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: CGFloat) -> [UIColor] {
        let colors = NSMutableArray()
        let count = from.count
        for i in 0..<count {
            let fromColor = from[i]
            let toColor = to[i]
            colors.add(ChartUIColorTween(fromColor, toColor).lerp(t))
        }
        return colors as! [UIColor]
    }
    
}


@objc(WQChartCGFloatArrayTween)
open class ChartCGFloatArrayTween: NSObject {
    
    @objc public private(set) var from: [CGFloat]
    @objc public private(set) var to: [CGFloat]
    
    @objc(initWithFrom:to:)
    public init(_ from: [CGFloat], _ to: [CGFloat]) {
        assert(from.count == to.count, "from and to arrays must be of equal length")
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func lerp(_ t: CGFloat) -> [CGFloat] {
        let colors = NSMutableArray()
        let count = from.count
        for i in 0..<count {
            let fromColor = from[i]
            let toColor = to[i]
            colors.add(ChartCGFloatTween(fromColor, toColor).lerp(t))
        }
        return colors as! [CGFloat]
    }
    
}
