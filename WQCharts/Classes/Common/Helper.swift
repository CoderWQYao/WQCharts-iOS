// https://github.com/CoderWQYao/WQCharts-iOS
//
// Helper.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class Helper: NSObject {

    @objc
    open class func angleIn360Degree(_ angle: CGFloat) -> CGFloat {
        var result = fmod(angle, 360)
        if(result < 0) {
            result += 360
        }
        return result
    }

    @objc
    open class func convertAngleToRadian(_ angle: CGFloat) -> CGFloat {
         return CGFloat.pi / 180.0 * angle
    }
    
    @objc
    open class func convertRadianToAngle(_ radian: CGFloat) -> CGFloat {
        return radian * 180 / CGFloat.pi
    }

    open class func createRectPath(_ rect: CGRect, _  angle: CGFloat, _ cornerRadius1: CGFloat, _ cornerRadius2: CGFloat, _ cornerRadius3: CGFloat, _ cornerRadius4: CGFloat) -> CGPath {
        
        let path = CGMutablePath()
        let count = 4
        let origin = rect.origin
        let size = rect.size
        var points = [
            CGPoint(x: origin.x, y: origin.y + size.height),
            CGPoint(x: origin.x, y: origin.y),
            CGPoint(x: origin.x + size.width, y: origin.y),
            CGPoint(x: origin.x + size.width, y: origin.y + size.height)
        ]
        
        let angle = angleIn360Degree(angle)
        var isMatched = false
        var matchingAngle:CGFloat = 0
        for i in 0..<count {
            if matchingAngle==angle {
                isMatched = true
                var tempPoints: [CGPoint] = [CGPoint](repeating: .zero, count: 4)
                for j in 0..<count {
                    tempPoints[j] = points[(i + j) % count]
                }
                points = tempPoints
                break
            }
            matchingAngle += 90
        }
        
        if !isMatched {
            return path
        }
        
        var cornerAngle = matchingAngle
        let cornerRadii = [cornerRadius1,cornerRadius2,cornerRadius3,cornerRadius4]
        for i in 0..<count {
            let cornerRadius = cornerRadii[i]
            let point = points[i]
            if(cornerRadius>0 && min(size.width, size.height)>=cornerRadius) {
                let offsetRadian = convertAngleToRadian(cornerAngle + 45)
                let offsetDistance = sqrt(cornerRadius * cornerRadius * 2)
                let center = CGPoint(x: point.x + offsetDistance * sin(offsetRadian), y: point.y - offsetDistance * cos(offsetRadian))
                path.addRelativeArc(center: center, radius: cornerRadius, startAngle: convertAngleToRadian(-90 + cornerAngle + 180), delta: convertAngleToRadian(90))
            } else if(i==0) {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            cornerAngle += 90
        }
        path.closeSubpath()
        
        return path
    }

}
