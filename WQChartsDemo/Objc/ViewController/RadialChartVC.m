// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "RadialChartVC.h"

@interface RadialChartVC ()

@end

@implementation RadialChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Padding")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQRadialChartView* chartView = weakSelf.radialChartView;
        CGFloat padding = selection != 0 ? 30 : 0;
        chartView.padding = UIEdgeInsetsMake(padding, padding, padding, padding);
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Angle")
     .setOptions(@[@"360",@"180"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQRadialChartView* chartView = weakSelf.radialChartView;
        WQRadialChart* chart = (WQRadialChart*)[chartView valueForKey:@"chart"];
        chart.angle = selection != 0 ? 180 : 360;
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"CounterClockwise")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQRadialChartView* chartView = weakSelf.radialChartView;
        WQRadialChart* chart = (WQRadialChart*)[chartView valueForKey:@"chart"];
        chart.direction = selection !=0 ? WQPieChartDirectionCounterClockwise : WQPieChartDirectionClockwise;
        [chartView redraw];
    })];
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"Rotation")
     .addItem(SliderCell.new
              .setSliderValue(0,360,0)
              .setOnValueChange(^(SliderCell* cell,float value) {
        WQRadialChartView* chartView = weakSelf.radialChartView;
        WQRadialChart* chart = (WQRadialChart*)[chartView valueForKey:@"chart"];
        chart.rotation = value;
        [chartView redraw];
    }))];
    
    self.radialChartView.onRotationChange = ^(WQRadialChartView * _Nonnull chartView, CGFloat rotation, CGFloat translation) {
        [weakSelf updateSliderValueForKey:@"Rotation" index:0 value:rotation];
    };
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.radialChartView.frame = self.chartContainer.bounds;
}

@end
