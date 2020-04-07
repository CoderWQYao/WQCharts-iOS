// https://github.com/CoderWQYao/WQCharts-iOS
//
// WQPolygonChart+ObjcSupport.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WQCharts/WQCharts-Swift.h>
#import "CGPolygonGraphic.h"


@interface WQPolygonChart (ObjcSupport)

@property (nonatomic, copy) NSArray<NSObject *> * _Nullable items;
- (CGPolygonGraphic * _Nonnull)drawGraphicInRect:(CGRect)rect context:(CGContextRef _Nonnull)context;

@property (nonatomic) NSString* aabbcc;

@end

