// https://github.com/CoderWQYao/WQCharts-iOS
//
// TransformUIColor.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQTransformUIColor)
open class TransformUIColor: NSObject {

    public private(set) var from: UIColor
    public private(set) var to: UIColor
    
    @objc(initWithFrom:to:)
    public init(_ from: UIColor, _ to: UIColor) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func valueForProgress(_ progress: CGFloat) -> UIColor {
        var fromR = CGFloat(0), fromG = CGFloat(0), fromB = CGFloat(0), fromA = CGFloat(0)
        from.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
        
        var toR = CGFloat(0), toG = CGFloat(0), toB = CGFloat(0), toA = CGFloat(0)
        to.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        
        return UIColor(red: (toR - fromR) * progress + fromR, green: (toG - fromG) * progress + fromG, blue: (toB - fromB) * progress + fromB, alpha: (toA - fromA) * progress + fromA)
    }
    
}
