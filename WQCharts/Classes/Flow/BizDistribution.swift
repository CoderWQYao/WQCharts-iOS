// https://github.com/CoderWQYao/WQCharts-iOS
//
// BizDistribution.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQBizDistribution)
open class BizDistribution: NSObject {
    
    @objc public var items: [BizDistributionItem]?
    @objc public var lowerBound = CGFloat(0)
    @objc public var upperBound = CGFloat(0)
    
}
