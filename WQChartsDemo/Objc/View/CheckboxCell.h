// https://github.com/CoderWQYao/WQCharts-iOS
//
// CheckboxCell.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "ButtonsCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckboxCell : ButtonsCell

@property (nonatomic, copy) NSArray<NSNumber*>* selections;
@property (nonatomic, copy) void(^onSelectionsChange)(CheckboxCell* cell, NSArray<NSNumber*>* selections);

- (CheckboxCell*(^)(NSString* title))setTitle;
- (CheckboxCell*(^)(NSArray<NSString*>* options))setOptions;
- (CheckboxCell*(^)(NSArray<NSNumber*>* selections))setSelections;
- (CheckboxCell*(^)(void(^onSelectionsChange)(CheckboxCell* cell, NSArray<NSNumber*>* selections)))setOnSelectionsChange;

- (void)callSectionsChange;

@end

NS_ASSUME_NONNULL_END
