// 代码地址: 
// UIColor+WQCharts.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ColorHex(hex) [UIColor colorWithHexString:hex]

@interface UIColor (WQCharts)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor*)rgbRandom;
- (UIColor*)invert;

@end

NS_ASSUME_NONNULL_END
