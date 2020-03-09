// https://github.com/CoderWQYao/WQCharts-iOS
//
// BarGraphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQBarGraphic)
open class BarGraphic: CoordinateGraphic {
    
    @objc open var items: [BarGraphicItem]?
    
    @objc(findNearestItemAtPoint:)
    open func findNearestItem(_ point: CGPoint) -> BarGraphicItem? {
        return findNearestItem(point, rect)
    }
    
    @objc(findNearestItemAtPoint:inRect:)
    open func findNearestItem(_ point: CGPoint, _ rect: CGRect) -> BarGraphicItem? {
        guard let items = items else {
            return nil
        }
        
        var nearestItemOp: BarGraphicItem? = nil
        for item in items {
            let itemString = item.stringStart
            if exchangeXY {
                if itemString.y < rect.minY || itemString.y > rect.maxY {
                    continue
                }
                if let nearestItem = nearestItemOp {
                    if abs(point.y - itemString.y) < abs(point.y - nearestItem.stringStart.y) {
                        nearestItemOp = item
                    }
                } else {
                    nearestItemOp = item
                }
            } else {
                if itemString.x < rect.minX || itemString.x > rect.maxX {
                    continue
                }
                if let nearestItem = nearestItemOp {
                    if abs(point.x - itemString.x) < abs(point.x - nearestItem.stringStart.x) {
                        nearestItemOp = item
                    }
                } else {
                    nearestItemOp = item
                }
            }
        }
        return nearestItemOp
    }
    
}
