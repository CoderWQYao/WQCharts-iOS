// 代码地址: 
// BaseChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "BaseChartVC.h"

@interface BaseChartVC()

@end

@implementation BaseChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_Block_BG;
    
    ListView* optionsView = [[ListView alloc] init];
    optionsView.backgroundColor = Color_Block_Card;
    [self.view addSubview:optionsView];
    self.optionsView = optionsView;
    
    UIView* chartContainer = [[UIView alloc] init];
    [self.view addSubview:chartContainer];
    self.chartContainer = chartContainer;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    
    UIScrollView* optionsView = self.optionsView;
    CGFloat optionsViewWidth = 120;
    optionsView.frame = CGRectMake(width - optionsViewWidth, 0, optionsViewWidth, height);
    contentInset.right = optionsViewWidth;
    
    UIView* chartContainer = self.chartContainer;
    chartContainer.frame = CGRectMake(contentInset.left, contentInset.top, width - contentInset.left - contentInset.right, height - contentInset.top - contentInset.bottom);
    
}


#pragma mark - Cells Support

- (void)setupStrokePaint:(WQLinePaint* _Nullable)paint color:(UIColor* _Nullable)color type:(NSInteger)type {
    paint.color = color;
    switch (type) {
        case 1:
            paint.width = 1;
            paint.dashLengths = nil;
            break;
        case 2:
            paint.width = 1;
            paint.dashLengths = @[@4,@2];
            break;
        default:
            paint.width = 0;
            paint.dashLengths = nil;
            break;
    }
}

- (ListCell*)findListCellForKey:(NSString*)key {
    for (UIView* cell in self.optionsView.items) {
        if(![cell isKindOfClass:ListCell.class]) {
            continue;
        }
        
        ListCell* listCell = (ListCell*)cell;
        if([key isEqualToString:listCell.title]) {
            return listCell;
        }
    }
    return nil;
}

- (NSUInteger)radioCellSelectionForKey:(NSString*)key {
    for (UIView* cell in self.optionsView.items) {
        if(![cell isKindOfClass:RadioCell.class]) {
            continue;
        }
        
        RadioCell* radioCell = (RadioCell*)cell;
        if([key isEqualToString:radioCell.title]) {
            return radioCell.selection;
        }
    }
    return 0;
}

- (void)updateSliderValueForKey:(NSString*)key index:(NSUInteger)index value:(CGFloat)value {
    ListCell* listCell = [self findListCellForKey:key];
    SliderCell* sliderCell = (SliderCell*)listCell.contentView.items[index];
    if(![sliderCell isKindOfClass:SliderCell.class]) {
        return;
    }
    sliderCell.value = value;
}

- (CGFloat)sliderValueForKey:(NSString*)key index:(NSUInteger)index {
    ListCell* listCell = [self findListCellForKey:key];
    SliderCell* sliderCell = (SliderCell*)listCell.contentView.items[index];
    if(![sliderCell isKindOfClass:SliderCell.class]) {
        return 0;
    }
    return sliderCell.value;
}

- (CGFloat)sliderIntegerValueForKey:(NSString*)key index:(NSUInteger)index {
    CGFloat value = [self sliderValueForKey:key index:index];
    return (NSInteger)round(value);
}


- (void)scrollToListCellForKey:(NSString*)key atScrollPosition:(ListViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [self.optionsView setNeedsLayoutItems];
    ListCell* cell = [self findListCellForKey:key];
    NSInteger index = [self.optionsView.items indexOfObject:cell];
    [self.optionsView scrollToItemAtIndex:index atScrollPosition:scrollPosition animated:animated];
}

- (void)callRadioCellsSectionChange {
    for (UIView* cell in self.optionsView.items) {
        if(![cell isKindOfClass:RadioCell.class]) {
            continue;
        }
        
        RadioCell* radioCell = (RadioCell*)cell;
        [radioCell callSectionChange];
    }
}

@end
