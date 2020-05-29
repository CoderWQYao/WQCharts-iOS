// https://github.com/CoderWQYao/WQCharts-iOS
//
// Chart.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQChart)
public protocol Chart {
   
    @objc func draw(inRect rect: CGRect, context: CGContext)
    
}
