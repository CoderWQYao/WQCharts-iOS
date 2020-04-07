// https://github.com/CoderWQYao/WQCharts-iOS
//
// Animation.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQAnimationDelegate)
public protocol AnimationDelegate {
    
    @objc optional func animationDidStart(_ animation: Animation)
    @objc optional func animationDidStop(_ animation: Animation, finished: Bool)
    
    @objc optional func animation(_ animation: Animation, progressWillChange progress: CGFloat)
    @objc optional func animation(_ animation: Animation, progressDidChange progress: CGFloat)
    
}

@objc(WQAnimation)
open class Animation: ChartItem {
    
    @objc open weak var delegate: AnimationDelegate?
    
    @objc open private(set) var transformable: Transformable
    @objc open private(set) var interpolator: Interpolator
    @objc open private(set) var startTime: TimeInterval = -1
    @objc open private(set) var duration: TimeInterval = 0.0
    @objc open private(set) var lastTransformationTime: TimeInterval = -1
    
    private var started: Bool = false
    private var ended: Bool = false
    
    @objc(initWithTransformable:duration:)
    public convenience init(_ transformable: Transformable, _ duration: TimeInterval) {
        self.init(transformable, duration, nil)
    }
    
    @objc(initWithTransformable:duration:interpolator:)
    public init(_ transformable: Transformable, _ duration: TimeInterval, _ interpolator: Interpolator?) {
        self.transformable = transformable
        self.duration = duration
        self.interpolator = interpolator ?? LinearInterpolator()
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
            transformable.clearTransforms()
            delegate?.animationDidStop?(self, finished: true)
            ended = true
        }
        return true
    }
    
    private func nextTransformation(withProgress progress: CGFloat) {
        let interpolationProgress = interpolator.interpolation(withInput: progress)
        delegate?.animation?(self, progressWillChange: interpolationProgress)
        transformable.nextTransform(interpolationProgress)
        delegate?.animation?(self, progressDidChange: interpolationProgress)
    }
    
    @objc open func cancel() {
        if (started && !ended) {
            lastTransformationTime = Date().timeIntervalSince1970
            nextTransformation(withProgress: 1)
            transformable.clearTransforms()
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
