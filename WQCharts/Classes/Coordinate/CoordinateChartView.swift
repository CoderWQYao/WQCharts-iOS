// https://github.com/CoderWQYao/WQCharts-iOS
//
// CoordinateChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit


@objc(WQCoordinateChartView)
open class CoordinateChartView: ChartView {
    
    @objc open var chartAsCoordinate: CoordinateChart {
        fatalError("chartAsCoordinate has not been implemented")
    }
    
    @objc open var graphicAsCoordinate: CoordinateGraphic? {
        fatalError("graphicAsCoordinate has not been implemented")
    }

}
