// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// ListView.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "ListView.h"

@interface ListView() {
    NSMutableArray<UIView*>* _items;
    BOOL _needsReload;
    CGSize _lastLayoutSize;
    NSInteger _scrollItemIndex;
    ListViewScrollPosition _scrollItemPosition;
    BOOL _scrollItemAnimated;
}


@end


@implementation ListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(!self) {
        return nil;
    }
    
    _needsReload = YES;
    _scrollItemIndex = NSNotFound;
    _items = [NSMutableArray array];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    if(_needsReload || !CGSizeEqualToSize(_lastLayoutSize, size)) {
        _needsReload = NO;
        
        CGFloat width = size.width;
        CGFloat offsetY = 0;
        for (UIView* item in self.items) {
            CGFloat cellHeight = [item sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
            item.frame = CGRectMake(0, offsetY, width, cellHeight);
            offsetY = CGRectGetMaxY(item.frame);
        }
        
        self.contentSize = CGSizeMake(width, offsetY);
        
        if(_scrollItemIndex!=NSNotFound) {
            [self scrollToItemAtIndex:_scrollItemIndex atScrollPosition:_scrollItemPosition animated:_scrollItemAnimated];
            _scrollItemIndex = NSNotFound;
            _scrollItemPosition = ListViewScrollPositionTop;
            _scrollItemAnimated = NO;
        }
        
    }
    
    _lastLayoutSize = size;
    
    
}

- (NSArray<UIView *> *)items {
    return _items;
}

- (void)setItems:(NSArray<UIView *> *)items {
    for (UIView* item in _items) {
        if(item.superview == self) {
            [item removeFromSuperview];
        }
    }
    
    _items = [NSMutableArray arrayWithCapacity:items.count];
    
    for (UIView* item in items) {
        [self addSubview:item];
        [_items addObject:item];
    }
    
    [self setNeedsLayoutItems];
}

- (void)addItem:(UIView*)item {
    [self addSubview:item];
    [_items addObject:item];
    [self setNeedsLayoutItems];
}

- (void)removeItem:(UIView *)item {
    [_items removeObject:item];
    NSInteger index = [self.subviews indexOfObject:item];
    if(index == NSNotFound) {
        return;
    }
    [item removeFromSuperview];
    [self setNeedsLayoutItems];
}

- (void)removeItemAt:(NSInteger)index {
    UIView* item = _items[index];
    [self removeItem:item];
}

- (void)setNeedsLayoutItems {
    _needsReload = YES;
    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat contentHeight = 0;
    for (UIView* item in self.items) {
        contentHeight += [item sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)].height;
    }
    return CGSizeMake(size.width, MIN(size.height, contentHeight));
}

- (void)scrollToItemAtIndex:(NSInteger)index atScrollPosition:(ListViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if(_needsReload) {
        _scrollItemIndex = index;
        _scrollItemPosition = scrollPosition;
        _scrollItemAnimated = animated;
        return;
    }
    
    CGPoint contentOffset = self.contentOffset;
    UIView* item = self.items[index];
    switch (scrollPosition) {
        case ListViewScrollPositionMiddle:
            contentOffset.y = CGRectGetMidY(item.frame) - self.bounds.size.height / 2;
            break;
        case ListViewScrollPositionBottom:
            contentOffset.y = MAX(0,CGRectGetMaxY(item.frame) - self.bounds.size.height);
            break;
        default:
            contentOffset.y = MIN(self.contentSize.height - self.bounds.size.height, CGRectGetMinY(item.frame));
            break;
    }
    [self setContentOffset:contentOffset animated:animated];
}

@end
