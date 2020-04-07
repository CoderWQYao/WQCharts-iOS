// https://github.com/CoderWQYao/WQCharts-iOS
//
// TransformInt.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQTransformInt)
open class TransformInt: NSObject {

    public private(set) var from: Int
    public private(set) var to: Int
    
    @objc(initWithFrom:to:)
    public init(_ from: Int, _ to: Int) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func valueForProgress(_ progress: Float) -> Int {
        return Int(roundf(Float(to - from) * progress)) + from
    }
    
    
}
