// https://github.com/CoderWQYao/WQCharts-iOS
//
// LinearInterpolator.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/**
* An interpolator where the rate of change is constant
*/
@objc(WQLinearInterpolator)
open class LinearInterpolator: NSObject, Interpolator {
    
    public func interpolation(withInput input: CGFloat) -> CGFloat {
        return input
    }
    
}
