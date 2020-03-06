// 代码地址: 
// SliderCell.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SliderCell;

typedef void(^SliderCellOnValueChange)(SliderCell*,float);

@interface SliderCell : UIView

@property (nonatomic, strong) id object;
@property (nonatomic) float value;
@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) NSInteger decimalCount;
@property (nonatomic, copy) SliderCellOnValueChange onValueChange;

- (void)callSliderValueChange;

- (SliderCell*(^)(float,float,float))setSliderValue;
- (SliderCell*(^)(NSInteger))setDecimalCount;
- (SliderCell*(^)(id))setObject;
- (SliderCell*(^)(SliderCellOnValueChange))setOnValueChange;

@end

NS_ASSUME_NONNULL_END
