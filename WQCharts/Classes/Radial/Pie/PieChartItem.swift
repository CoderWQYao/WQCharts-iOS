// https://github.com/CoderWQYao/WQCharts-iOS
//
// PieChartItem.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQPieChartItem)
open class PieChartItem: ChartItem {
    
    @objc open var value = CGFloat(0)
    @objc open var arc1Scale = CGFloat(0)
    @objc open var arc2Scale = CGFloat(0)
    @objc open var driftRatio = CGFloat(0)
    @objc open var paint: ShapePaint?
    @objc open var text: ChartText?
    
    @objc open var transformValue: TransformCGFloat?
    @objc open var transformArc1Scale: TransformCGFloat?
    @objc open var transformArc2Scale: TransformCGFloat?
    @objc open var transformDriftRatio: TransformCGFloat?
    
    @objc
    public override convenience init() {
        self.init(0)
    }
    
    @objc(initWithValue:)
    public init(_ value: CGFloat) {
        super.init()
        self.value = value
        self.paint = ShapePaint()
        self.arc2Scale = 0
        self.arc1Scale = 1
    }
    
    @objc(totalValueWithItems:)
    open class func getTotalValue(_ items: [PieChartItem]?) -> CGFloat {
        var totalValue = CGFloat(0)
        guard let items = items else {
            return totalValue
        }
        
        for item in items {
            totalValue += item.value
        }
        return totalValue
    }
    
    override open func nextTransform(_ progress: CGFloat) {
        super.nextTransform(progress)
        
        if let transformValue = transformValue {
            value = transformValue.valueForProgress(progress)
        }
        
        if let transformArc1Scale = transformArc1Scale {
            arc1Scale = transformArc1Scale.valueForProgress(progress)
        }
        
        if let transformArc2Scale = transformArc2Scale {
            arc2Scale = transformArc2Scale.valueForProgress(progress)
        }
        
        if let transformDriftRatio = transformDriftRatio {
            driftRatio = transformDriftRatio.valueForProgress(progress)
        }
        
        paint?.nextTransform(progress)
    }
    
    override open func clearTransforms() {
        super.clearTransforms()
        
        transformValue = nil
        transformArc1Scale = nil
        transformArc2Scale = nil
        transformDriftRatio = nil
        paint?.clearTransforms()
    }
    
}
