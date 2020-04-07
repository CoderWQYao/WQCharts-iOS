// https://github.com/CoderWQYao/WQCharts-iOS
//
// AccelerateInterpolator.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/**
* An interpolator where the rate of change starts out slowly and
* and then accelerates.
*/
@objc(WQAccelerateInterpolator)
open class AccelerateInterpolator: NSObject, Interpolator {
    
    private let factor: CGFloat

    @objc
    public convenience override init() {
        self.init(1)
    }
    
    @objc(initWithFactor:)
    public init(_ factor: CGFloat) {
        self.factor = factor
        super.init()
    }
    
    public func interpolation(withInput input: CGFloat) -> CGFloat {
        if factor == 1 {
            return input * input
        } else {
            return pow(input, 2 * factor)
        }
    }
    
}
