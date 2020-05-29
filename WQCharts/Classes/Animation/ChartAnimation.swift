// https://github.com/CoderWQYao/WQCharts-iOS
//
// Animation.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit


@objc(WQChartAnimatable)
public protocol ChartAnimatable {
    
    ///
    /// The value of `t` is nominally a fraction in the range 0.0 to 1.0, though
    /// in practice it may extend outside this range.
    ///
    func transform(_ t: CGFloat)
    func clearAnimationElements()
    
}

@objc(WQChartAnimationDelegate)
public protocol ChartAnimationDelegate {
    
    @objc optional func animationDidStart(_ animation: ChartAnimation)
    @objc optional func animationDidStop(_ animation: ChartAnimation, finished: Bool)
    
    @objc optional func animation(_ animation: ChartAnimation, progressWillChange progress: CGFloat)
    @objc optional func animation(_ animation: ChartAnimation, progressDidChange progress: CGFloat)
    
}

@objc(WQChartAnimation)
open class ChartAnimation: NSObject {
    
    @objc open weak var delegate: ChartAnimationDelegate?
    
    @objc open private(set) var animatable: ChartAnimatable
    @objc open private(set) var interpolator: ChartInterpolator
    @objc open private(set) var startTime: TimeInterval = -1
    @objc open private(set) var duration: TimeInterval = 0.0
    @objc open private(set) var lastTransformationTime: TimeInterval = -1
    
    private var started: Bool = false
    private var ended: Bool = false
    
    @objc(initWithAnimatable:duration:)
    public convenience init(_ animatable: ChartAnimatable, _ duration: TimeInterval) {
        self.init(animatable, duration, ChartLinearInterpolator())
    }
    
    @objc(initWithAnimatable:duration:interpolator:)
    public init(_ animatable: ChartAnimatable, _ duration: TimeInterval, _ interpolator: ChartInterpolator) {
        self.animatable = animatable
        self.duration = duration
        self.interpolator = interpolator
        super.init()
    }
    
    @objc open func nextTransformation(withTime time: TimeInterval) -> Bool {
        if ended {
            return false
        }
        
        if !started {
            startTime = time
            delegate?.animationDidStart?(self)
            started = true
        }
        
        let startTime = self.startTime
        var progress = CGFloat((time - startTime) / duration)
        if progress < 0 {
            progress = 0
        } else if progress > 1 {
            progress = 1
        }
        lastTransformationTime = time
        nextTransformation(withProgress: progress)
        if progress >= 1 {
            animatable.clearAnimationElements()
            delegate?.animationDidStop?(self, finished: true)
            ended = true
        }
        return true
    }
    
    private func nextTransformation(withProgress progress: CGFloat) {
        let interpolationProgress = interpolator.interpolation(withInput: progress)
        delegate?.animation?(self, progressWillChange: interpolationProgress)
        animatable.transform(interpolationProgress)
        delegate?.animation?(self, progressDidChange: interpolationProgress)
    }
    
    @objc open func cancel() {
        if (started && !ended) {
            lastTransformationTime = Date().timeIntervalSince1970
            nextTransformation(withProgress: 1)
            animatable.clearAnimationElements()
            delegate?.animationDidStop?(self, finished: false)
            ended = true
        }
    }
    
    open func reset() {
        startTime = -1
        started = false
        ended = false
    }
    
}
