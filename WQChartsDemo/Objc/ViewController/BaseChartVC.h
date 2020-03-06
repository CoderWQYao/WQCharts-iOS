// 代码地址: 
// BaseChartVC.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListView.h"
#import "RadioCell.h"
#import "ListCell.h"
#import "SliderCell.h"
#import "SectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseChartVC : UIViewController

@property (nonatomic, strong) UIView* chartContainer;
@property (nonatomic, strong) ListView* optionsView;


#pragma mark - Paint Support
- (void)setupStrokePaint:(WQLinePaint* _Nullable)paint color:(UIColor* _Nullable)color type:(NSInteger)type;

#pragma mark - Cells Support
- (ListCell*)findListCellForKey:(NSString*)key;
- (NSUInteger)radioCellSelectionForKey:(NSString*)key;
- (void)updateSliderValueForKey:(NSString*)key index:(NSUInteger)index value:(CGFloat)value;
- (CGFloat)sliderValueForKey:(NSString*)key index:(NSUInteger)index;
- (CGFloat)sliderIntegerValueForKey:(NSString*)key index:(NSUInteger)index;
- (void)scrollToListCellForKey:(NSString*)key atScrollPosition:(ListViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)callRadioCellsSectionChange;

@end

NS_ASSUME_NONNULL_END
