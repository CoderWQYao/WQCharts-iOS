// https://github.com/CoderWQYao/WQCharts-iOS
//
// Interpolator.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQChartInterpolator)
public protocol ChartInterpolator {

    @objc func interpolation(withInput input: CGFloat) -> CGFloat
    
}

/**
* An interpolator where the rate of change is constant
*/
@objc(WQChartLinearInterpolator)
open class ChartLinearInterpolator: NSObject, ChartInterpolator {
    
    public func interpolation(withInput input: CGFloat) -> CGFloat {
        return input
    }
    
}


/**
* An interpolator where the rate of change starts out slowly and
* and then accelerates.
*/
@objc(WQChartAccelerateInterpolator)
open class ChartAccelerateInterpolator: NSObject, ChartInterpolator {
    
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

/**
* An interpolator where the rate of change starts out quickly and
* and then decelerates.
*/
@objc(WQChartDecelerateInterpolator)
open class ChartDecelerateInterpolator: NSObject, ChartInterpolator {
    
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
