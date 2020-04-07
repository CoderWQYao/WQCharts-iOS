// https://github.com/CoderWQYao/WQCharts-iOS
//
// Transformable.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit


@objc(WQTransformable)
public protocol Transformable {
    
    func nextTransform(_ progress: CGFloat)
    func clearTransforms()
    
}
