// https://github.com/CoderWQYao/WQCharts-iOS
//
// ChartText.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQChartTextDelegate)
public protocol ChartTextDelegate {
    
    @objc optional func chartText(_ chartText: ChartText, fixedSizeWithAngle angle: NSNumber?) -> NSValue?
    @objc optional func chartText(_ chartText: ChartText, offsetByAngleWithSize size: CGSize, angle: CGFloat) -> CGFloat
    @objc optional func chartText(_ chartText: ChartText, offsetWithSize size: CGSize, angle: NSNumber?) -> CGPoint
    
}

@objc(WQChartTextBlocks)
open class ChartTextBlocks: NSObject, ChartTextDelegate {
    
    public typealias fixedSizeBlock = (_ chartText: ChartText, _ angle: NSNumber?) -> NSValue?
    public typealias offsetByAngleBlock = (_ chartText: ChartText, _ size: CGSize, _ angle: CGFloat) -> CGFloat
    public typealias offsetBlock = (_ chartText: ChartText, _ size: CGSize, _ angle: NSNumber?) -> CGPoint
             
    @objc open var fixedSize: fixedSizeBlock?
    @objc open var offsetByAngle: offsetByAngleBlock?
    @objc open var offset: offsetBlock?
    
    public func chartText(_ chartText: ChartText, fixedSizeWithAngle angle: NSNumber?) -> NSValue? {
        return fixedSize?(chartText, angle)
    }
    
    public func chartText(_ chartText: ChartText, offsetByAngleWithSize size: CGSize, angle: CGFloat) -> CGFloat {
        return offsetByAngle?(chartText, size, angle) ?? 0
    }
    
    public func chartText(_ chartText: ChartText, offsetWithSize size: CGSize, angle: NSNumber?) -> CGPoint {
        return offset?(chartText, size, angle) ?? .zero
    }
    
}

@objc(WQChartText)
open class ChartText: ChartItem {
    
    @objc open var attributedString: NSAttributedString?
    
    @objc open var string: String?
    
    @objc open var attributes = [NSAttributedString.Key : Any]()
    
    @objc open var font: UIFont? {
        get {
            return attributes[NSAttributedString.Key.font] as? UIFont
        }
        set {
            attributes[NSAttributedString.Key.font] = newValue
        }
    }
    
    @objc open var color: UIColor? {
        get {
            return attributes[NSAttributedString.Key.foregroundColor] as? UIColor
        }
        set {
            attributes[NSAttributedString.Key.foregroundColor] = newValue
        }
    }
    
    @objc open var alignment: NSTextAlignment {
        get {
            if let paragraphStyle: NSMutableParagraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
                return paragraphStyle.alignment
            }
            return .left
        }
        set {
            let paragraphStyle: NSMutableParagraphStyle
            if let paragraphStyle_op: NSMutableParagraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
                paragraphStyle = paragraphStyle_op.mutableCopy() as! NSMutableParagraphStyle
            } else {
                paragraphStyle = NSMutableParagraphStyle()
                attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            }
            paragraphStyle.alignment = newValue
        }
    }
    
    @objc open var backgroundColor: UIColor?
    @objc open var options: NSStringDrawingOptions = .usesLineFragmentOrigin
    
    @objc open weak var delegate: ChartTextDelegate? {
        didSet {
            if let delegateUsingBlock = delegateUsingBlocks, !delegateUsingBlock.isEqual(delegate) {
                self.delegateUsingBlocks = nil
            }
        }
    }
    
    @objc open var delegateUsingBlocks: ChartTextBlocks? {
        didSet {
            if let delegateUsingBlocks = delegateUsingBlocks {
                delegate = delegateUsingBlocks
            }
        }
    }
    
    @objc open var fitSize: CGSize {
        get {
            if let attributedString = buildAttributedString() {
                return attributedString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: options, context: nil).size
            }
            return CGSize.zero
        }
    }
    
    @objc open var hidden = false
    
    @objc
    public override init() {
        super.init()
        self.font = .systemFont(ofSize: 9)
        self.color = .black
    }
    
    @objc(drawAtPoint:angle:inContext:)
    open func draw(_ point: CGPoint, _ angle: NSNumber?, _ context: CGContext) {
        
        if hidden {
            return
        }
        
        context.saveGState()
        
        var rectSize: CGSize
        if let fixedSize = delegate?.chartText?(self, fixedSizeWithAngle: angle) {
            rectSize = fixedSize.cgSizeValue
        } else {
            rectSize = fitSize
        }
        
        var rectPoint = CGPoint(x: point.x - rectSize.width / 2, y: point.y - rectSize.height / 2)
        
        if let angle = angle != nil ? CGFloat(truncating: angle!) : nil, let offsetByAngle = delegate?.chartText?(self, offsetByAngleWithSize: rectSize, angle: angle) {
            let radian: CGFloat = CGFloat.pi / 180 * angle
            rectPoint.x += offsetByAngle * sin(radian)
            rectPoint.y -= offsetByAngle * cos(radian)
        }
        
        if let offset = delegate?.chartText?(self, offsetWithSize: rectSize, angle: angle) {
            rectPoint.x += offset.x
            rectPoint.y += offset.y
        }
        
        let rect = CGRect(origin: rectPoint, size: rectSize)
        let path = CGPath(rect: rect, transform: nil)
        
        if let backgroundColor = backgroundColor {
            context.beginPath()
            context.addPath(path)
            context.setFillColor(backgroundColor.cgColor)
            context.fill(rect)
        }
        
        if let attributedString = buildAttributedString() {
            attributedString.draw(with: rect, options: options, context: nil)
        }
        
        context.restoreGState()
    }
    
    @objc
    open func buildAttributedString() -> NSAttributedString?  {
        if let attributedString = attributedString {
            return attributedString
        }
        if let string = string {
            return NSAttributedString(string: string, attributes: attributes)
        }
        return nil
    }
    
}
