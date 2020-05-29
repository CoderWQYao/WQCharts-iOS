// https://github.com/CoderWQYao/WQCharts-iOS
//
// BaseChartVC.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListView.h"
#import "RadioCell.h"
#import "CheckboxCell.h"
#import "ListCell.h"
#import "SliderCell.h"
#import "SectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BaseChartVC;

@protocol ItemsOptionsDelegate <NSObject>

@property (nonatomic, readonly) NSMutableArray* items;
@property (nonatomic, readonly) NSString* itemsOptionTitle;
- (id)createItemAtIndex:(NSInteger)index;
- (UIView*)createItemCellWithItem:(id)item atIndex:(NSInteger)index;
- (void)itemsDidChange:(NSMutableArray*)items;

@end

@interface BaseChartVC : UIViewController<WQChartAnimationDelegate>

@property (nonatomic, readonly) UIView* chartContainer;
@property (nonatomic, readonly) ListView* optionsView;
@property (nonatomic, readonly) UIView* chartViewRef;
@property (nonatomic, readonly) WQChartAnimationPlayer* animationPlayer;
@property (nonatomic, readonly) NSTimeInterval animationDuration;
@property (nonatomic, readonly) id<WQChartInterpolator> animationInterpolator;

- (UIView*)createChartView;
- (void)chartViewDidCreate:(UIView*)chartView;
- (void)configChartOptions;
- (void)configChartItemsOptions;

#pragma mark - Paint

- (void)setupStrokePaint:(WQChartLinePaint* _Nullable)paint color:(UIColor* _Nullable)color type:(NSInteger)type;

#pragma mark - Cell

- (ListCell*)findListCellForKey:(NSString*)key;
- (RadioCell*)findRadioCellForKey:(NSString*)key;
- (NSInteger)radioCellSelectionForKey:(NSString*)key;
- (void)updateSliderValue:(CGFloat)value forKey:(NSString*)key atIndex:(NSUInteger)index;
- (CGFloat)sliderValueForKey:(NSString*)key atIndex:(NSUInteger)index;
- (CGFloat)sliderIntegerValueForKey:(NSString*)key atIndex:(NSUInteger)index;
- (void)scrollToListCellForKey:(NSString*)key atScrollPosition:(ListViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)callRadioCellsSectionChange;

#pragma mark - Animation

- (void)configAnimationOptions;
- (void)appendAnimationKeys:(NSMutableArray<NSString*>*)animationKeys;
- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys;
- (void)appendAnimationsInArray:(NSMutableArray<WQChartAnimation*>*)array forKeys:(NSArray<NSString*>*)keys;

@end

NS_ASSUME_NONNULL_END
