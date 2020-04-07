// https://github.com/CoderWQYao/WQCharts-iOS
//
// TransformFloat.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQTransformFloat)
open class TransformFloat: NSObject {

    public private(set) var from: Float
    public private(set) var to: Float
    
    @objc(initWithFrom:to:)
    public init(_ from: Float, _ to: Float) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func valueForProgress(_ progress: Float) -> Float {
        return (to - from) * progress + from
    }
    
}
