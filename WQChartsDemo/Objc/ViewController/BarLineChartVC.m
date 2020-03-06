// 代码地址: 
// BarLineChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "BarLineChartVC.h"

@interface BarLineChartVC ()


@end

@implementation BarLineChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Padding")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updatePaddingExchangeXY];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ExchangeXY")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updatePaddingExchangeXY];
        [weakSelf.view setNeedsLayout];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ReverseX")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQCoordinateChartView* chartView = weakSelf.barLineChartView;
        WQCoordinateChart* chart = (WQCoordinateChart*)[chartView valueForKey:@"chart"];
        chart.reverseX = selection != 0;
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ReverseY")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQCoordinateChartView* chartView = weakSelf.barLineChartView;
        WQCoordinateChart* chart = (WQCoordinateChart*)[chartView valueForKey:@"chart"];
        chart.reverseY = selection != 0;
        [chartView redraw];
    })];
    
}



- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIView* chartContainer = self.chartContainer;
    CGFloat width = chartContainer.bounds.size.width;
    CGFloat height = chartContainer.bounds.size.height;
    
    CGFloat minLength = MIN(width, height);
    CGFloat chartViewWidth;
    CGFloat chartViewHeight;
    if([self radioCellSelectionForKey:@"ExchangeXY"] != 0) {
        chartViewWidth = minLength;
        chartViewHeight = chartViewWidth / 0.7;
        if(chartViewHeight > height) {
            CGFloat scale = height / chartViewHeight;
            chartViewHeight = height;
            chartViewWidth *= scale;
        }
        
    } else {
        chartViewHeight = minLength;
        chartViewWidth = chartViewHeight / 0.7;
        if(chartViewWidth > width) {
            CGFloat scale = width / chartViewWidth;
            chartViewWidth = width;
            chartViewHeight *= scale;
        }
    }
    self.barLineChartView.frame = CGRectMake((width - chartViewWidth) / 2, (height - chartViewHeight) / 2, chartViewWidth, chartViewHeight);
}


- (void)updatePaddingExchangeXY {
    WQCoordinateChartView* chartView = self.barLineChartView;
    UIEdgeInsets padding = [self radioCellSelectionForKey:@"Padding"] != 0 ? UIEdgeInsetsMake(20, 20, 20, 20) : UIEdgeInsetsZero;
    
    BOOL exchangeXY = [self radioCellSelectionForKey:@"ExchangeXY"] != 0;
    if(exchangeXY) {
        padding.left = 30;
        padding.right = 30;
    }
    chartView.padding = padding;
    
    WQCoordinateChart* chart = (WQCoordinateChart*)[chartView valueForKey:@"chart"];
    chart.exchangeXY = exchangeXY;
    
    [self updateItems];
    [chartView redraw];
}

- (void)updateItems {
    
}

@end
