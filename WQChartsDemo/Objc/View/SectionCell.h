// 代码地址: 
// SectionCell.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 
@class SectionCell;

typedef void(^SectionCellReloadHandler)(SectionCell* cell);

@interface SectionCell : UIView

@property (nonatomic, readonly) UILabel* textLabel;
@property (nonatomic, readonly) UIButton* button;
@property (nonatomic, strong) id objcect;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) SectionCellReloadHandler onReload;

- (SectionCell*(^)(id))setObject;
- (SectionCell*(^)(NSString*))setTitle;
- (SectionCell*(^)(SectionCellReloadHandler))setOnReload;

@end

NS_ASSUME_NONNULL_END
