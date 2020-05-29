// https://github.com/CoderWQYao/WQCharts-iOS
//
// Animatable.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit


@objc(WQAnimatable)
public protocol ChartAnimatable {
    
    ///
    /// The value of `t` is nominally a fraction in the range 0.0 to 1.0, though
    /// in practice it may extend outside this range.
    ///
    func transform(_ t: CGFloat)
    func clearTransforms()
    
}
