// https://github.com/CoderWQYao/WQCharts-iOS
//
// AreaGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQAreaGraphic)
open class AreaGraphic: CoordinateGraphic {

    @objc open var stringStart = CGPoint.zero
    @objc open var stringEnd = CGPoint.zero
    @objc open var path: CGPath?
    @objc open var items: [AreaGraphicItem]?
    
    @objc(findNearestItemInLocation:)
    open func findNearestItem(_ location: CGPoint) -> AreaGraphicItem? {
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
                if abs(location.y - item.endPoint.y) < abs(location.y - nearestItem.endPoint.y) {
                    nearestItem = item
                }
            } else {
                if abs(location.x - item.endPoint.x) < abs(location.x - nearestItem.endPoint.x) {
                    nearestItem = item
                }
            }
        }
        return nearestItem
    }
    
}
