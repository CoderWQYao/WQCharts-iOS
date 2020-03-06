// 代码地址: 
// ListView.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ListViewScrollPosition) {
    ListViewScrollPositionTop,
    ListViewScrollPositionMiddle,
    ListViewScrollPositionBottom
};

@interface ListView : UIScrollView

@property (nonatomic, strong) NSArray<UIView*>* items;

- (void)addItem:(UIView*)item;
- (void)removeItem:(UIView*)item;
- (void)removeItemAt:(NSInteger)index;
- (void)setNeedsLayoutItems;
- (void)scrollToItemAtIndex:(NSInteger)index atScrollPosition:(ListViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
