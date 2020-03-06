// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// UIColor+WQCharts.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "UIColor+WQCharts.h"


@implementation UIColor (WQCharts)

+ (UIColor *)colorWithHexString:(NSString *)hexString {

    NSString* colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    NSString* alphaString = @"";
    NSString* redString = @"";
    NSString* greenString = @"";
    NSString* blueString = @"";
    
    switch ([colorString length]) {
        case 6: // #RRGGBB
            alphaString = @"FF";
            redString = [colorString substringWithRange:NSMakeRange(0, 2)];
            greenString = [colorString substringWithRange:NSMakeRange(2, 2)];
            blueString = [colorString substringWithRange:NSMakeRange(4, 2)];
            break;
        case 8: // #AARRGGBB
            alphaString = [colorString substringWithRange:NSMakeRange(0, 2)];
            redString   = [colorString substringWithRange:NSMakeRange(2, 2)];
            greenString = [colorString substringWithRange:NSMakeRange(4, 2)];
            blueString  = [colorString substringWithRange:NSMakeRange(6, 2)];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    
    UInt32 alpha = 0;
    UInt32 red = 0;
    UInt32 green = 0;
    UInt32 blue = 0;
    
    [[[NSScanner alloc] initWithString:alphaString] scanHexInt:&alpha];
    [[[NSScanner alloc] initWithString:redString] scanHexInt:&red];
    [[[NSScanner alloc] initWithString:greenString] scanHexInt:&green];
    [[[NSScanner alloc] initWithString:blueString] scanHexInt:&blue];
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha: alpha / 255.0];
}


+ (UIColor*)rgbRandom {
    CGFloat R = (arc4random() % 256) / (CGFloat)255;
    CGFloat G = (arc4random() % 256) / (CGFloat)255;
    CGFloat B = (arc4random() % 256) / (CGFloat)255;
    return [UIColor colorWithRed:R green:G blue:B alpha:1];
}

- (UIColor *)invert {
    CGFloat R, G, B, A;
    [self getRed:&R green:&G blue:&B alpha:&A];
    return [UIColor colorWithRed:1.0 - R green:1.0 - G blue:1.0 - B alpha:A];
}

@end
