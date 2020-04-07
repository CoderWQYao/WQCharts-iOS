// https://github.com/CoderWQYao/WQCharts-iOS
//
// NSNumber+Random.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Random)

+ (CGFloat)randomCGFloatFrom:(CGFloat)from to:(CGFloat)to;
+ (NSInteger)randomIntegerFrom:(NSInteger)from to:(NSInteger)to;
+ (BOOL)randomBOOL;

@end

NS_ASSUME_NONNULL_END
