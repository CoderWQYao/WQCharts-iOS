// https://github.com/CoderWQYao/WQCharts-iOS
//
// TransformCGRect.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQTransformCGRect)
open class TransformCGRect: NSObject {
    
    public private(set) var from: CGRect
    public private(set) var to: CGRect
    
    @objc(initWithFrom:to:)
    public init(_ from: CGRect, _ to: CGRect) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func valueForProgress(_ progress: CGFloat) -> CGRect {
        return CGRect(x: (to.minX - from.minX) * progress + from.minX,
        y: (to.minY - from.minY) * progress + from.minY,
        width: (to.width - from.width) * progress + from.width,
        height: (to.height - from.height) * progress + from.height)
    }
}
