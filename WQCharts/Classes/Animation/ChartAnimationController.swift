// https://github.com/CoderWQYao/WQCharts-iOS
//
// AnimationPlayer.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQChartAnimationPlayer)
open class ChartAnimationController: NSObject {
    
    @objc private var animations: NSMutableArray
    
    private weak var displayView: UIView?
    private weak var displayTarget: AnyObject?
    private var action: Selector?
    private var displayLink: CADisplayLink?
    
    @objc public init(displayView: UIView) {
        animations = NSMutableArray()
        self.displayView = displayView
        super.init()
    }
    
    @objc public init(displayTarget: AnyObject?, action: Selector) {
        animations = NSMutableArray()
        self.displayTarget = displayTarget
        self.action = action
        super.init()
    }
    
    @objc open func startAnimation(_ animation: ChartAnimation) {
        if animations.contains(animation) {
            return
        }
        animations.add(animation)
        if displayLink == nil {
            let displayLink = CADisplayLink(target: self, selector: #selector(next))
            displayLink.add(to: RunLoop.main, forMode: .common)
            self.displayLink = displayLink
        }
    }
    
    @objc open func startAnimations(_ animations: [ChartAnimation]) {
        for animation in animations {
            startAnimation(animation)
        }
    }
    
    @objc open func removeAnimation(_ animation: ChartAnimation) {
        if animations.contains(animation) {
            animations.remove(animation)
            animation.cancel()
        }
        
        if animations.count == 0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    @objc open func removeAnimations(_ animations: [ChartAnimation]) {
        for animation in animations {
            removeAnimation(animation)
        }
    }
    
    @objc open func clearAnimations() {
        removeAnimations(animations as! [ChartAnimation])
    }
    
    @objc private func next() {
        let animations = self.animations
        let needsRemoveAnimations = NSMutableArray()
        
        for i in 0..<animations.count {
            let animation = animations[i] as! ChartAnimation
            let currentTime = Date().timeIntervalSince1970
            if !animation.nextTransformation(withTime: currentTime) {
                needsRemoveAnimations.add(animation)
            }
        }
        
        removeAnimations(needsRemoveAnimations as! [ChartAnimation])
        displayView?.setNeedsDisplay()
        _ = displayTarget?.perform(action)
    }
    
    
    
}
