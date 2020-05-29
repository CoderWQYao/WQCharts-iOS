// https://github.com/CoderWQYao/WQCharts-iOS
//
// CoordinateChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "CoordinateChartVC.h"

@interface CoordinateChartVC ()

@property (nonatomic, readonly) WQCoordinateChartView* coordinateChartView;

@end

@implementation CoordinateChartVC

- (WQCoordinateChartView *)coordinateChartView {
    return (WQCoordinateChartView *)self.chartViewRef;
}

- (void)layoutRectangleChartView {
    WQCoordinateChartView* chartView = self.coordinateChartView;
    CGFloat width = self.chartContainer.bounds.size.width;
    CGFloat height = self.chartContainer.bounds.size.height;
    CGFloat minLength = MIN(width, height);
    CGFloat chartViewWidth;
    CGFloat chartViewHeight;
    if (chartView.chartAsCoordinate.exchangeXY) {
        chartViewWidth = minLength;
        chartViewHeight = chartViewWidth / 0.7;
        if (chartViewHeight > height) {
            CGFloat scale = height / chartViewHeight;
            chartViewHeight = height;
            chartViewWidth *= scale;
        }
    } else {
        chartViewHeight = minLength;
        chartViewWidth = chartViewHeight / 0.7;
        if (chartViewWidth > width)  {
            CGFloat scale = width / chartViewWidth;
            chartViewWidth = width;
            chartViewHeight *= scale;
        }
    }
    
    chartView.frame = CGRectMake((width - chartViewWidth) / 2, (height - chartViewHeight) / 2, chartViewWidth, chartViewHeight);
}

- (void)chartViewDidCreate:(WQCoordinateChartView *)chartView {
    chartView.drawDelegate = self;
}

- (void)configChartOptions {
    [super configChartOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Padding")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        weakSelf.coordinateChartView.padding = [weakSelf chartViewPaddingForSelection:selection];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ExchangeXY")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateChartExchangeXY];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ReverseX")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQCoordinateChartView* chartView = weakSelf.coordinateChartView;
        chartView.chartAsCoordinate.reverseX = selection != 0;
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ReverseY")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQCoordinateChartView* chartView = weakSelf.coordinateChartView;
        chartView.chartAsCoordinate.reverseY = selection != 0;
        [chartView redraw];
    })];
    
}

- (UIEdgeInsets)chartViewPaddingForSelection:(NSInteger)selection {
    UIEdgeInsets padding;
    if (selection != 0) {
        padding = UIEdgeInsetsMake(20, 20, 20, 20);
        if (self.coordinateChartView.chartAsCoordinate.exchangeXY) {
            padding.left = 30;
            padding.right = 30;
        }
    } else {
        padding = UIEdgeInsetsZero;
    }
    return padding;
}

- (void)updateChartExchangeXY {
    WQCoordinateChartView* chartView = self.coordinateChartView;
    chartView.chartAsCoordinate.exchangeXY = [self radioCellSelectionForKey:@"ExchangeXY"] != 0;
    [chartView redraw];
}

#pragma mark - ChartViewDrawDelegate

- (void)chartViewWillDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    
}

- (void)chartViewDidDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    
}

#pragma mark - Animation

- (void)appendAnimationKeys:(NSMutableArray<NSString *> *)animationKeys {
    [super appendAnimationKeys:animationKeys];
    [animationKeys addObject:@"Padding"];
    [animationKeys addObject:@"Clip"];
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    [super prepareAnimationOfChartViewForKeys:keys];
    
    WQCoordinateChartView* chartView = self.coordinateChartView;
    
    if ([keys containsObject:@"Padding"]) {
        RadioCell* paddingCell = [self findRadioCellForKey:@"Padding"];
        UIEdgeInsets padding;
        if (paddingCell.selection == 0) {
            padding = [self chartViewPaddingForSelection:1];
        } else {
            padding = [self chartViewPaddingForSelection:0];
        }
        chartView.paddingTween = [[WQChartUIEdgeInsetsTween alloc] initWithFrom:chartView.padding to:padding];
        paddingCell.selection = paddingCell.selection == 0 ? 1 : 0;
    }
    
    if ([keys containsObject:@"Clip"]) {
        CGRect rect = chartView.bounds;
        BOOL exchangeXY = chartView.chartAsCoordinate.exchangeXY;
        BOOL isReversed = [NSNumber randomBOOL];
        if (exchangeXY) {
            if (isReversed) {
                chartView.clipRectTween = [[WQChartCGRectTween alloc] initWithFrom:
                                               CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetWidth(rect), 0)
                                                                                   to:
                                               CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
            } else {
                chartView.clipRectTween = [[WQChartCGRectTween alloc] initWithFrom:
                                               CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), 0)
                                                                                   to:
                                               CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
            }
        } else {
            if (isReversed) {
                chartView.clipRectTween = [[WQChartCGRectTween alloc] initWithFrom:
                                               CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), 0, CGRectGetHeight(rect))
                                                                                   to:
                                               CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
            } else {
                chartView.clipRectTween = [[WQChartCGRectTween alloc] initWithFrom:
                                               CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), 0, CGRectGetHeight(rect))
                                                                                   to:
                                               CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
            }
        }
    }
    
}

@end
