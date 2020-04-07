// https://github.com/CoderWQYao/WQCharts-iOS
//
// TransformDouble.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQTransformDouble)
open class TransformDouble: NSObject {
    
    public private(set) var from: Double
    public private(set) var to: Double
    
    @objc(initWithFrom:to:)
    public init(_ from: Double, _ to: Double) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func valueForProgress(_ progress: Double) -> Double {
        return (to - from) * progress + from
    }
    
}
