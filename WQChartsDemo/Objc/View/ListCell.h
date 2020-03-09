// https://github.com/CoderWQYao/WQCharts-iOS
//
// ListCell.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListCell : UIView

@property (nonatomic, readonly) UILabel* titleLabel;
@property (nonatomic, readonly) ListView* contentView;

@property (nonatomic, copy) NSString* title;
@property (nonatomic) BOOL isMutable;
@property (nonatomic, copy) void(^onAppend)(ListCell*);
@property (nonatomic, copy) void(^onRemove)(ListCell*);

- (ListCell*(^)(NSString*))setTitle;
- (ListCell*(^)(BOOL))setIsMutable;
- (ListCell*(^)(NSArray<UIView*>*))setItems;
- (ListCell*(^)(void(^)(ListCell*)))setOnAppend;
- (ListCell*(^)(void(^)(ListCell*)))setOnRemove;
- (ListCell*(^)(UIView*))addItem;
- (ListCell*(^)(NSInteger))removeItemAtIndex;

@end

NS_ASSUME_NONNULL_END
