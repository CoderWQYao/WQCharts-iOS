// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class RadialChartVC<T: RadialChartView>: BaseChartVC<T> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsView.addItem(RadioCell()
            .setTitle("Padding")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak chartView](cell, selection) in
                let padding: CGFloat = selection != 0 ? 30 : 0
                chartView?.padding = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("Angle")
            .setOptions(["360","180"])
            .setSelection(0)
            .setOnSelectionChange({[weak chartView](cell, selection) in
                guard let chartView = chartView else {
                    return
                }
                let chart = chartView.value(forKey: "chart") as! RadialChart
                chart.angle = selection != 0 ? 180 : 360
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("CounterClockwise")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak chartView](cell, selection) in
                guard let chartView = chartView else {
                    return
                }
                let chart = chartView.value(forKey: "chart") as! RadialChart
                chart.direction = selection != 0 ? .CounterClockwise : .Clockwise
                chartView.redraw()
            })
        )
        
        optionsView.addItem(ListCell()
            .setTitle("Rotation")
            .addItem(SliderCell()
                .setSliderValue(0,360,0)
                .setOnValueChange({[weak chartView](cell, value) in
                    guard let chartView = chartView else {
                        return
                    }
                    let chart = chartView.value(forKey: "chart") as! RadialChart
                    chart.rotation = value
                    chartView.redraw()
                })
            )
        )
        
        chartView.onRotationChange = {[weak self](chartView, rotation, translation) in
            guard let self = self else {
                return
            }
            self.updateSliderValue("Rotation", 0, rotation)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        chartView.frame = chartContainer.bounds
    }
    
}
