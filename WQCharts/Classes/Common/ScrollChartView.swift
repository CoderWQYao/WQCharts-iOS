// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// ScrollChartView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

/// 滚动图表
@objc(WQScrollChartView)
open class ScrollChartView: UIScrollView, UIGestureRecognizerDelegate {
   
    /// 用于标记layout记录
    private var layoutSize = CGSize.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        prepare()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
        removeObserver(self, forKeyPath: "contentSize")
    }
    
    func prepare() {
        addObserver(self, forKeyPath: "contentOffset", options: [.new,.old], context: nil)
        addObserver(self, forKeyPath: "contentSize", options: [.new,.old], context: nil)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
       
        guard let dict = change else {
            return
        }
        
        if keyPath == "contentOffset" {
            let oldValue = dict[NSKeyValueChangeKey.oldKey] as! CGPoint
            let newValue = dict[NSKeyValueChangeKey.newKey] as! CGPoint
            if oldValue.equalTo(newValue)  {
               return
            }
        } else if keyPath == "contentSize" {
            let oldValue = dict[NSKeyValueChangeKey.oldKey] as! CGSize
            let newValue = dict[NSKeyValueChangeKey.newKey] as! CGSize
            if oldValue.equalTo(newValue)  {
               return
            }
        }
        
        redraw()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if !layoutSize.equalTo(bounds.size) {
            layoutSize = bounds.size
            redraw()
        }
    }
    
    /// 重新绘制
    @objc
    public func redraw() {
        setNeedsDisplay()
    }
    
    
}
