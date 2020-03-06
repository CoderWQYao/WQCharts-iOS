// 代码地址: 
// BarLineChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class BarLineChartVC<T: CoordinateChartView>: BaseChartVC<T> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsView.addItem(RadioCell()
            .setTitle("Padding")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updatePaddingExchangeXY()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ExchangeXY")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                self.updatePaddingExchangeXY()
                self.view.setNeedsLayout()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ReverseX")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                let chart = chartView.value(forKey: "chart") as! CoordinateChart
                chart.reverseX = selection != 0
                chartView.redraw()
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ReverseY")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                let chartView = self.chartView
                let chart = chartView.value(forKey: "chart") as! CoordinateChart
                chart.reverseY = selection != 0
                chartView.redraw()
            })
        )
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let chartView = self.chartView
        let width = chartContainer.bounds.size.width
        let height = chartContainer.bounds.size.height
        let minLength = min(width, height)
        var chartViewWidth: CGFloat
        var chartViewHeight: CGFloat
        if radioCellSelectionForKey("ExchangeXY") != 0 {
            chartViewWidth = minLength
            chartViewHeight = chartViewWidth / 0.7
            if chartViewHeight > height {
                let scale = height / chartViewHeight
                chartViewHeight = height
                chartViewWidth *= scale
            }
        } else {
            chartViewHeight = minLength
            chartViewWidth = chartViewHeight / 0.7
            if chartViewWidth > width  {
                let scale = width / chartViewWidth
                chartViewWidth = width
                chartViewHeight *= scale
            }
        }
        chartView.frame = CGRect(x: (width - chartViewWidth) / 2, y: (height - chartViewHeight) / 2, width: chartViewWidth, height: chartViewHeight)
    }
    
    func updatePaddingExchangeXY() {
        let chartView = self.chartView
        
        var padding = radioCellSelectionForKey("Padding") != 0 ? UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) : .zero
        let exchangeXY = radioCellSelectionForKey("ExchangeXY") != 0
        if exchangeXY {
            padding.left = 30
            padding.right = 30
        }
        chartView.padding = padding
        
        let chart = chartView.value(forKey: "chart") as! CoordinateChart
        chart.exchangeXY = exchangeXY
        
        updateItems()
        chartView.redraw()
    }
    
    func updateItems() {
        
    }
}
