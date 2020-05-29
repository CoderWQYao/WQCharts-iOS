// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class RadialChartVC<T: RadialChartView>: BaseChartVC<T>, ChartViewDrawDelegate, RadialChartViewRotationDelegate {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        chartView.frame = chartContainer.bounds
    }
    
    override func chartViewDidCreate(_ chartView: T) {
        super.chartViewDidCreate(chartView)
        chartView.drawDelegate = self
        chartView.rotationDelegate = self
    }
    
    override func configChartOptions() {
        super.configChartOptions()
        
        optionsView.addItem(RadioCell()
            .setTitle("Padding")
            .setOptions(["OFF","ON"])
            .setSelection(1)
            .setOnSelectionChange({[weak chartView](cell, selection) in
                guard let chartView = chartView else {
                    return
                }
                let paddingValue: CGFloat = selection != 0 ? 30 : 0
                chartView.padding = UIEdgeInsets(top: paddingValue, left: paddingValue, bottom: paddingValue, right: paddingValue)
            })
        )
        
        optionsView.addItem(ListCell()
            .setTitle("Angle")
            .addItem(SliderCell()
                .setSliderValue(0,360,360)
                .setOnValueChange({[weak chartView](cell, value) in
                    guard let chartView = chartView else {
                        return
                    }
                    let chart = chartView.chartAsRadial
                    chart.angle = value
                    chartView.redraw()
                })
            )
        )
        
        optionsView.addItem(ListCell()
            .setTitle("Rotation")
            .addItem(SliderCell()
                .setSliderValue(0,360,0)
                .setOnValueChange({[weak chartView](cell, value) in
                    guard let chartView = chartView else {
                        return
                    }
                    let chart = chartView.chartAsRadial
                    chart.rotation = value
                    chartView.redraw()
                })
            )
        )
        
        optionsView.addItem(RadioCell()
            .setTitle("CounterClockwise")
            .setOptions(["OFF","ON"])
            .setSelection(0)
            .setOnSelectionChange({[weak chartView](cell, selection) in
                guard let chartView = chartView else {
                    return
                }
                let chart = chartView.chartAsRadial
                chart.direction = selection != 0 ? .CounterClockwise : .Clockwise
                chartView.redraw()
            })
        )
        
    }
    
    // MARK: - ChartViewDrawDelegate
    
    func chartViewWillDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext) {
        
    }
    
    func chartViewDidDraw(_ chartView: ChartView, inRect rect: CGRect, context: CGContext) {
        
    }
    
    
    // MARK: - RadialChartViewRotationDelegate
    
    func radialChartView(_ radialChartView: RadialChartView, rotationDidChange rotation: CGFloat, translation: CGFloat) {
        updateSliderValue(rotation, forKey: "Rotation", atIndex: 0)
        print("radialChartView:", "rotationDidChange:", rotation, "translation:", translation)
    }
    
    
    // MARK: - Animation
    
    override func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        super.appendAnimationKeys(animationKeys)
        animationKeys.add("Padding")
        animationKeys.add("Clip")
        animationKeys.add("Angle")
        animationKeys.add("Rotation")
    }
    
    override func prepareAnimationOfChartView(forKeys keys: [String]) {
        super.prepareAnimationOfChartView(forKeys: keys)
        
        let chartView = self.chartView
        
        if keys.contains("Padding") {
            let paddingCell = findRadioCellForKey("Padding")!
            let paddingValue: CGFloat
            if paddingCell.selection == 0  {
                paddingValue = 30
            } else {
                paddingValue = 0
            }
            let padding = UIEdgeInsets(top: paddingValue, left: paddingValue, bottom: paddingValue, right: paddingValue)
            chartView.paddingTween = ChartUIEdgeInsetsTween(chartView.padding, padding)
            paddingCell.selection = paddingCell.selection == 0 ? 1 : 0
        }
        
        if keys.contains("Clip"), let graphic = chartView.graphicAsRadial {
            let center = graphic.center
            let radius = graphic.radius
            chartView.clipRectTween = ChartCGRectTween(CGRect(origin: center, size: .zero), CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
        }
        
        let chart = chartView.chartAsRadial
        
        if keys.contains("Angle") {
            var angle = CGFloat.random(in: 0...360 + 90)
            angle = min(angle, 360)
            chart.angleTween = ChartCGFloatTween(chart.angle, angle)
        }
        
        if keys.contains("Rotation") {
            chart.rotationTween = ChartCGFloatTween(chart.rotation, CGFloat.random(in: 0...360))
        }
    }
    
    // MARK: - AnimationDelegate
    
    override func animation(_ animation: ChartAnimation, progressDidChange progress: CGFloat) {
        super.animation(animation, progressDidChange: progress)
        
        if chartView.isEqual(animation.animatable) {
            let chart = chartView.chartAsRadial
            updateSliderValue(chart.angle, forKey: "Angle", atIndex: 0)
            updateSliderValue(chart.rotation, forKey: "Rotation", atIndex: 0)
        }
    }
    
}
