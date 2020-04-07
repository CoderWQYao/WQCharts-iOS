// https://github.com/CoderWQYao/WQCharts-iOS
//
// ButtonsCell.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ButtonsCellStyleNormal = 0,
    ButtonsCellStyleRadio,
    ButtonsCellStyleCheckBox,
} ButtonsCellStyle;

@interface ButtonsCell : UIView

#pragma mark - Public

@property (nonatomic, readonly) UILabel* titleLabel;
@property (nonatomic, readonly) UIView* buttonsWrap;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) NSArray<NSString*>* options;
@property (nonatomic) ButtonsCellStyle style;

#pragma mark - Internal

- (void)rebuildButtons;
- (void)adjustButtonStyle:(UIButton*)button isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
