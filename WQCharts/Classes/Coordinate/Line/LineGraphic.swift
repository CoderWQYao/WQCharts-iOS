// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// LineGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQLineGraphic)
open class LineGraphic: CoordinateGraphic {
    
    @objc open var stringStart = CGPoint.zero
    @objc open var stringEnd = CGPoint.zero
    @objc open var shapePath: CGPath?
    @objc open var linePath: CGPath?
    @objc open var items: [LineGraphicItem]?
    
    @objc(findNearestItemInLocation:)
    open func findNearestItem(_ location: CGPoint) -> LineGraphicItem? {
        guard let items = items else {
            return nil
        }
        
        let itemCount = items.count
        if itemCount == 0 {
            return nil
        }
        
        var nearestItem = items[0]
        let exchangeXY = self.exchangeXY
        for i in 1..<itemCount {
            let item = items[i]
            if exchangeXY {
                if abs(location.y - item.linePoint.y) < abs(location.y - nearestItem.linePoint.y) {
                    nearestItem = item
                }
            } else {
                if abs(location.x - item.linePoint.x) < abs(location.x - nearestItem.linePoint.x) {
                    nearestItem = item
                }
            }
        }
        return nearestItem
    }
    
}
