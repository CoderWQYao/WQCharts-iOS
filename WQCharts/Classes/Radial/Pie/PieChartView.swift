// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPieChartViewGraphicItemClickDelegate)
public protocol PieChartViewGraphicItemClickDelegate {
    
    @objc func pieChartView(_ pieChartView: PieChartView, graphicItemDidClick graphicItem: PieGraphicItem)
     
}

@objc(WQPieChartView)
open class PieChartView: RadialChartView {
    
    @objc private(set) public var chart = PieChart()
    /// The last drew Graphic for Pie in View
    @objc private(set) public var graphic: PieGraphic?
    
    @objc open weak var graphicItemClickDelegate: PieChartViewGraphicItemClickDelegate?
    
    override open var chartAsRadial: RadialChart {
        return chart
    }
    
    override open var graphicAsRadial: RadialGraphic? {
        return graphic
    }
    
    override func prepare() {
        super.prepare()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
    }
    
    override open func draw(_ rect: CGRect, _ context: CGContext) {
        let graphic = chart.drawGraphic(rect, context)
        chart.drawText(graphic, context)
        self.graphic = graphic
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let delegate = graphicItemClickDelegate, let items = graphic?.items else {
            return
        }
        let touchLocation = gestureRecognizer.location(in: self)
        let itemCount = items.count
        for i in 0..<itemCount {
            let item = items[i]
            let path = item.path!
            if path.contains(touchLocation) {
                delegate.pieChartView(self, graphicItemDidClick: item)
            }
        }
    }
    
    override open func transform(_ t: CGFloat) {
        super.transform(t)
        chart.transform(t)
    }
    
    override open func clearAnimationElements() {
        super.clearAnimationElements()
        chart.clearAnimationElements()
    }
    
}
