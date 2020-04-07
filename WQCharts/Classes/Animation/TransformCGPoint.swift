// https://github.com/CoderWQYao/WQCharts-iOS
//
// TransformCGPoint.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQTransformCGPoint)
open class TransformCGPoint: NSObject {
    
    public private(set) var from: CGPoint
    public private(set) var to: CGPoint
    
    @objc(initWithFrom:to:)
    public init(_ from: CGPoint, _ to: CGPoint) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func valueForProgress(_ progress: CGFloat) -> CGPoint {
        return CGPoint(x: (to.x - from.x) * progress + from.x, y: (to.y - from.y) * progress + from.y)
    }
    
}
