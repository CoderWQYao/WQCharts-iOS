// https://github.com/CoderWQYao/WQCharts-iOS
//
// TransformUIEdgeInsets.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQTransformUIEdgeInsets)
open class TransformUIEdgeInsets: NSObject {
    
    public private(set) var from: UIEdgeInsets
    public private(set) var to: UIEdgeInsets
    
    @objc(initWithFrom:to:)
    public init(_ from: UIEdgeInsets, _ to: UIEdgeInsets) {
        self.from = from
        self.to = to
        super.init()
    }
    
    @objc open func valueForProgress(_ progress: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: (to.top - from.top) * progress + from.top,
        left: (to.left - from.left) * progress + from.left,
        bottom: (to.bottom - from.bottom) * progress + from.bottom,
        right: (to.right - from.right) * progress + from.right)
    }
}
