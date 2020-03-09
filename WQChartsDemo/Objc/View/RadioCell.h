// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadioCell.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RadioCell : UIView

@property (nonatomic, readonly) UILabel* titleLabel;
@property (nonatomic, readonly) UIView* buttonsView;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) NSArray<NSString*>* options;
@property (nonatomic) NSInteger selection;
@property (nonatomic, copy) void(^onSelectionChange)(RadioCell* cell, NSInteger index);

- (void)callSectionChange;

- (RadioCell*(^)(NSString* title))setTitle;
- (RadioCell*(^)(NSArray<NSString*>* options))setOptions;
- (RadioCell*(^)(NSInteger selection))setSelection;
- (RadioCell*(^)(void(^onSelectionChange)(RadioCell* cell, NSInteger index)))setOnSelectionChange;



@end

NS_ASSUME_NONNULL_END
