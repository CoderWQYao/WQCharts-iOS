// https://github.com/CoderWQYao/WQCharts-iOS
//
// Interpolator.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQInterpolator)
public protocol Interpolator {

    @objc func interpolation(withInput input: CGFloat) -> CGFloat
    
}


