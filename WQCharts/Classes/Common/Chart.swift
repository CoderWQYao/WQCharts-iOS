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
   
    @objc(drawRect:inContext:)
    func draw( _ rect: CGRect, _ context: CGContext)
    
}
