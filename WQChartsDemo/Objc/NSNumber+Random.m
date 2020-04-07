// https://github.com/CoderWQYao/WQCharts-iOS
//
// NSNumber+Random.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "NSNumber+Random.h"

@implementation NSNumber (Random)

+ (CGFloat)randomCGFloatFrom:(CGFloat)from to:(CGFloat)to {
    CGFloat result = (NSInteger)from + (arc4random() % ((NSInteger)to - (NSInteger)from));
    result += arc4random() / (CGFloat)UINT32_MAX;
    return result;
}

+ (NSInteger)randomIntegerFrom:(NSInteger)from to:(NSInteger)to {
    return from + (arc4random() % (to - from + 1));
}

+ (BOOL)randomBOOL {
    return [self randomIntegerFrom:0 to:1];
}


@end
