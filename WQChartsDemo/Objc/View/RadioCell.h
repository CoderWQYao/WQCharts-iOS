// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadioCell.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "ButtonsCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RadioCell : ButtonsCell

@property (nonatomic) NSInteger selection;
@property (nonatomic, copy) void(^onSelectionChange)(RadioCell* cell, NSInteger selection);

- (RadioCell*(^)(NSString* title))setTitle;
- (RadioCell*(^)(NSArray<NSString*>* options))setOptions;
- (RadioCell*(^)(NSInteger selection))setSelection;
- (RadioCell*(^)(void(^onSelectionChange)(RadioCell* cell, NSInteger selection)))setOnSelectionChange;

- (void)callSectionChange;

@end

NS_ASSUME_NONNULL_END
