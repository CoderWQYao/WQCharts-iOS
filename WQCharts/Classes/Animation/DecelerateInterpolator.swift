// https://github.com/CoderWQYao/WQCharts-iOS
//
// DecelerateInterpolator.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit


/**
* An interpolator where the rate of change starts out quickly and
* and then decelerates.
*/
@objc(WQDecelerateInterpolator)
open class DecelerateInterpolator: NSObject, Interpolator {
    
    private let factor: CGFloat
    
    @objc
    public convenience override init() {
        self.init(1.0)
    }
    
    @objc(initWithFactor:)
    public init(_ factor: CGFloat) {
        self.factor = factor
        super.init()
    }
    
    public func interpolation(withInput input: CGFloat) -> CGFloat {
        let result: CGFloat
        if factor == 1.0 {
            result = 1.0 - (1.0 - input) * (1.0 - input);
        } else {
            result = 1.0 - pow((1.0 - input), 2 * factor);
        }
        return result;
    }
    
}
