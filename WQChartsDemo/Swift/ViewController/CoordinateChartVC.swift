// https://github.com/CoderWQYao/WQCharts-iOS
//
// CoordinateChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class CoordinateChartVC<T: CoordinateChartView>: BaseChartVC<T>, ChartViewDrawDelegate {

    override func chartViewDidCreate(_ chartView: T) {
        super.chartViewDidCreate(chartView)
        chartView.drawDelegate = self
    }
    
    override func configChartOptions() {
        super.configChartOptions()
        
        optionsView.addItem(RadioCell()
            .setTitle("Padding")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak self](cell, selection) in
                guard let self = self else {
                    return
                }
                self.chartView.padding = self.chartViewPadding(forSelection: selection)
            })
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("ExchangeXY")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak self](cell, selection) in
                self?.updateChartExchangeXY()
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
                chartView.chartAsCoordinate.reverseX = selection != 0
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
                chartView.chartAsCoordinate.reverseY = selection != 0
                chartView.redraw()
            })
        )
        
    }
    
    func layoutRectangleChartView() {
        let chartView = self.chartView
        let width = chartContainer.bounds.size.width
        let height = chartContainer.bounds.size.height
        let minLength = min(width, height)
        var chartViewWidth: CGFloat
        var chartViewHeight: CGFloat
        if chartView.chartAsCoordinate.exchangeXY {
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
    
    func chartViewPadding(forSelection selection: Int) -> UIEdgeInsets {
        var padding = selection != 0 ? UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) : .zero
        let exchangeXY = chartView.chartAsCoordinate.exchangeXY
        if exchangeXY {
            padding.left = 30
            padding.right = 30
        }
        return padding
    }
    
    func updateChartExchangeXY() {
        chartView.chartAsCoordinate.exchangeXY = radioCellSelectionForKey("ExchangeXY") != 0
        chartView.redraw()
    }
    
    // MARK: - ChartViewDrawDelegate
    
    func chartViewWillDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext) {
        
    }
    
    func chartViewDidDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext) {
        
    }
    
    // MARK: - Animation
    
    override func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        super.appendAnimationKeys(animationKeys)
        animationKeys.add("Padding")
        animationKeys.add("Clip")
    }

    
    override func prepareAnimationOfChartView(forKeys keys: [String]) {
        super.prepareAnimationOfChartView(forKeys: keys)
        
        let chartView = self.chartView
        
        if keys.contains("Padding") {
            let paddingCell = findRadioCellForKey("Padding")!
            let padding: UIEdgeInsets
            if paddingCell.selection == 0  {
                padding = chartViewPadding(forSelection: 1)
            } else {
                padding = chartViewPadding(forSelection: 0)
            }
            chartView.transformPadding = TransformUIEdgeInsets(chartView.padding, padding)
            paddingCell.selection = paddingCell.selection == 0 ? 1 : 0
        }
        
        if keys.contains("Clip") {
            let rect = chartView.bounds
            let exchangeXY = chartView.chartAsCoordinate.exchangeXY
            let isReversed = Bool.random()
            if exchangeXY {
                if isReversed {
                   chartView.transformClipRect = TransformCGRect(
                       CGRect(x: rect.minX, y: rect.maxY, width: rect.width, height: 0),
                       CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                   )
                } else {
                   chartView.transformClipRect = TransformCGRect(
                       CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: 0),
                       CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                   )
                }
            } else {
                if isReversed {
                    chartView.transformClipRect = TransformCGRect(
                        CGRect(x: rect.maxX, y: rect.minY, width: 0, height: rect.height),
                        CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                    )
                } else {
                    chartView.transformClipRect = TransformCGRect(
                        CGRect(x: rect.minX, y: rect.minY, width: 0, height: rect.height),
                        CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                    )
                }
            }
        }
        
    }
    
}
