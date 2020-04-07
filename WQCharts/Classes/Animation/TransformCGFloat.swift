// https://github.com/CoderWQYao/WQCharts-iOS
//
// TransformCGFloat.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQTransformCGFloat)
open class TransformCGFloat: NSObject {
    
    public private(set) var from: CGFloat
    public private(set) var to: CGFloat
    
    @objc(initWithFrom:to:)
    public init(_ from: CGFloat, _ to: CGFloat) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func valueForProgress(_ progress: CGFloat) -> CGFloat {
        return (to - from) * progress + from
    }
    
}
