// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// ChartText.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@objc(WQChartText)
/// 图表文本
open class ChartText: BaseChartItem {
    
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
    
    /// NSValue  is used for objc compatibility
    @objc open var fixedSize: NSValue?
    @objc open var alignment: NSTextAlignment {
        get {
            if let paragraphStyle: NSMutableParagraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
                return paragraphStyle.alignment
            }
            return .left
        }
        set {
            let paragraphStyle: NSMutableParagraphStyle
            if let paragraphStyleUnbox: NSMutableParagraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
                paragraphStyle = paragraphStyleUnbox.mutableCopy() as! NSMutableParagraphStyle
            } else {
                paragraphStyle = NSMutableParagraphStyle()
                attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            }
            paragraphStyle.alignment = newValue
        }
    }
    
    @objc open var textOffsetByAngle: ((_ text: ChartText, _ size: CGSize, _ angle: CGFloat) -> CGFloat)?
    @objc open var textOffset: ((_ text: ChartText, _ size: CGSize, _ angle: NSNumber?) -> CGPoint)?
    @objc open var backgroundColor: UIColor?
    @objc open var options: NSStringDrawingOptions = .usesLineFragmentOrigin
    
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
    
    
    /// Draw the text In context
    /// - Parameters:
    ///   - point: point of chart in location
    ///   - angle: point angle, NSNumber is used for objc compatibility
    ///   - context: CoreGraphics context
    @objc(drawAtPoint:angle:inContext:)
    open func draw(_ point: CGPoint, _ angle: NSNumber?, _ context: CGContext) {
        
        if hidden {
            return
        }
        
        context.saveGState()
        
        var rectSize: CGSize
        if let fixedSize = fixedSize {
            rectSize = fixedSize.cgSizeValue
        } else {
            rectSize = fitSize
        }
        
        var rectPoint = CGPoint(x: point.x - rectSize.width / 2, y: point.y - rectSize.height / 2)
        
        if let angle = angle != nil ? CGFloat(truncating: angle!) : nil , let textOffsetByAngle = textOffsetByAngle {
            let offsetByRadian = textOffsetByAngle(self,rectSize,angle)
            let radian: CGFloat = CGFloat.pi / 180 * angle
            rectPoint.x += offsetByRadian * sin(radian)
            rectPoint.y -= offsetByRadian * cos(radian)
        }
        
        if let textOffset = textOffset {
            let offset = textOffset(self,rectSize,angle)
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
