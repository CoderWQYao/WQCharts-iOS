// https://github.com/CoderWQYao/WQCharts-iOS
//
// Graphic.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQGraphic)
open class Graphic: NSObject {
    
    @objc public let rect: CGRect
    @objc public let builder: Any
    
    @objc(initWithBuilder:rect:)
    public init(_ builder: Any,_ rect: CGRect) {
        self.builder = builder
        self.rect = rect
        super.init()
    }
    
    @objc public var center: CGPoint {
        get {
            return CGPoint(x: rect.midX,y: rect.midY)
        }
    }
    
    @objc public var radius: CGFloat {
        get {
            return min(rect.width, rect.height) / 2.0
        }
    }
    
}
