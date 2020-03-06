// 代码地址: 
// PieChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 表示饼图的视图
@objc(WQPieChartView)
open class PieChartView: RadialChartView {
    
    @objc private(set) public var chart = PieChart()
    @objc private(set) public var graphic: PieGraphic?
    @objc open var onGraphicItemClick: ((_ chartView: PieChartView, _ graphicItem: PieGraphicItem) -> Void)?
    
    override func prepare() {
        super.prepare()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
    }
    
    override open func draw(_ rect: CGRect, _ context: CGContext) {
        let graphic = chart.drawGraphic(rect, context)
        chart.drawText(graphic, context)
        self.graphic = graphic
    }
    
    open override func callRotationOffset(_ rotationOffset: CGFloat) {
        chart.rotation = Helper.angleIn360Degree(chart.rotation + rotationOffset)
        redraw()
        onRotationChange?(self,chart.rotation,rotationOffset)
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let items = graphic?.items, let onGraphicItemClick = onGraphicItemClick else {
            return
        }
        let touchLocation = gestureRecognizer.location(in: self)
        let itemCount = items.count
        for i in 0..<itemCount {
            let item = items[i]
            let path = item.path!
            if path.contains(touchLocation) {
                onGraphicItemClick(self, item)
            }
        }
    }
    
}
