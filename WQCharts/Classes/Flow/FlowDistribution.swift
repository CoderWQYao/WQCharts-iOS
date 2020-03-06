// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// FlowDistribution.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQFlowDistribution)
open class FlowDistribution: NSObject {
    
    @objc public var items: [FlowDistributionItem]?
    @objc public var lowerBound = CGFloat(0)
    @objc public var upperBound = CGFloat(0)
    
}
