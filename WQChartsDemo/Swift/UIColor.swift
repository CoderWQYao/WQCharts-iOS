// https://github.com/CoderWQYao/WQCharts-iOS
//
// UIColor.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(_ hexString: String) {
        let colorString = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        var alphaString:String = ""
        var redString:String = ""
        var greenString:String = ""
        var blueString:String = ""
        let start = colorString.startIndex
        switch colorString.count {
              case 6: // #RRGGBB
                  alphaString = "FF"
                  redString = String(colorString[colorString.index(start, offsetBy: 0) ..< colorString.index(start, offsetBy: 2)])
                  greenString = String(colorString[colorString.index(start, offsetBy: 2)..<colorString.index(start, offsetBy: 4)])
                  blueString = String(colorString[colorString.index(start, offsetBy: 4)..<colorString.index(start, offsetBy: 6)])
              case 8: // #AARRGGBB
                  alphaString = String(colorString[colorString.index(start, offsetBy: 0) ..< colorString.index(start, offsetBy: 2)])
                  redString = String(colorString[colorString.index(start, offsetBy: 2) ..< colorString.index(start, offsetBy: 4)])
                  greenString = String(colorString[colorString.index(start, offsetBy: 4) ..< colorString.index(start, offsetBy: 6)])
                  blueString = String(colorString[colorString.index(start, offsetBy: 6) ..< colorString.index(start, offsetBy: 8)])
              default:
                NSException.raise(NSExceptionName(rawValue: "Invalid color value"), format: "Color value %@ is invalid.  It should be a hex value of the form #RRGGBB or #AARRGGBB", arguments: getVaList([hexString]))
        }
        
        var alpha = UInt32(0)
        var red = UInt32(0)
        var green = UInt32(0)
        var blue = UInt32(0)
                         
        Scanner(string: alphaString).scanHexInt32(&alpha)
        Scanner(string: redString).scanHexInt32(&red)
        Scanner(string: greenString).scanHexInt32(&green)
        Scanner(string: blueString).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
      
    }
    
    open class func random() -> UIColor {
        let R = (CGFloat(arc4random() % 256)) / 255
        let G = (CGFloat(arc4random() % 256)) / 255
        let B = (CGFloat(arc4random() % 256)) / 255
        return UIColor.init(red: R, green: G, blue: B, alpha: 1)
    }
    
    open func invert() -> UIColor {
        var R = CGFloat(0)
        var G = CGFloat(0)
        var B = CGFloat(0)
        var A = CGFloat(0)
        self.getRed(&R, green: &G, blue: &B, alpha: &A)
        return UIColor(red: 1.0 - R, green: 1.0 - G, blue: 1.0 - B, alpha: A)
    }
}
