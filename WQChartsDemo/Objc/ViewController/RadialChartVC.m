// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadialChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "RadialChartVC.h"

@interface RadialChartVC ()

@property (nonatomic, readonly) WQRadialChartView* radialChartView;

@end

@implementation RadialChartVC

- (WQRadialChartView *)radialChartView {
    return (WQRadialChartView*)self.chartViewRef;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.radialChartView.frame = self.chartContainer.bounds;
}

- (void)chartViewDidCreate:(WQRadialChartView *)chartView {
    chartView.drawDelegate = self;
    chartView.rotationDelegate = self;
}

- (void)configChartOptions {
    [super configChartOptions];
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
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"Angle")
     .addItem(SliderCell.new
              .setSliderValue(0,360,360)
              .setOnValueChange(^(SliderCell* cell,float value) {
        WQRadialChartView* chartView = weakSelf.radialChartView;
        WQRadialChart* chart = chartView.chartAsRadial;
        chart.angle = value;
        [chartView redraw];
    }))];
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"Rotation")
     .addItem(SliderCell.new
              .setSliderValue(0,360,0)
              .setOnValueChange(^(SliderCell* cell,float value) {
        WQRadialChartView* chartView = weakSelf.radialChartView;
        WQRadialChart* chart = chartView.chartAsRadial;
        chart.rotation = value;
        [chartView redraw];
    }))];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"CounterClockwise")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQRadialChartView* chartView = weakSelf.radialChartView;
        WQRadialChart* chart = (WQRadialChart*)[chartView valueForKey:@"chart"];
        chart.direction = selection != 0 ? WQPieChartDirectionCounterClockwise : WQPieChartDirectionClockwise;
        [chartView redraw];
    })];
    
}

#pragma mark - ChartViewDrawDelegate

- (void)chartViewWillDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    
}

- (void)chartViewDidDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    
}

#pragma mark - RadialChartViewRotationDelegate

- (void)radialChartView:(WQRadialChartView *)radialChartView rotationDidChange:(CGFloat)rotation translation:(CGFloat)translation {
    [self updateSliderValue:rotation forKey:@"Rotation" atIndex:0];
    NSLog(@"radialChartView: rotationDidChange: %f translation: %f", rotation, translation);
}

#pragma mark - Animation

- (void)appendAnimationKeys:(NSMutableArray<NSString *> *)animationKeys {
    [super appendAnimationKeys:animationKeys];
    [animationKeys addObject:@"Padding"];
    [animationKeys addObject:@"Clip"];
    [animationKeys addObject:@"Angle"];
    [animationKeys addObject:@"Rotation"];
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    [super prepareAnimationOfChartViewForKeys:keys];
    
    WQRadialChartView* chartView = self.radialChartView;
    
    if ([keys containsObject:@"Padding"]) {
        RadioCell* paddingCell = [self findRadioCellForKey:@"Padding"];
        CGFloat paddingValue = paddingCell.selection == 0 ? 30 : 0;
        UIEdgeInsets padding = UIEdgeInsetsMake(paddingValue, paddingValue, paddingValue, paddingValue);
        chartView.transformPadding = [[WQTransformUIEdgeInsets alloc] initWithFrom:chartView.padding to:padding];
        paddingCell.selection = paddingCell.selection == 0 ? 1 : 0;
    }
    
    if ([keys containsObject:@"Clip"] && chartView.graphicAsRadial) {
        WQRadialGraphic* graphic = chartView.graphicAsRadial;
        CGPoint center = graphic.center;
        CGFloat radius = graphic.radius;
        chartView.transformClipRect = [[WQTransformCGRect alloc] initWithFrom:(CGRect){center,CGSizeZero} to:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    }
    
    WQRadialChart* chart = chartView.chartAsRadial;
    
    if ([keys containsObject:@"Angle"]) {
        CGFloat angle = [NSNumber randomCGFloatFrom:0 to:360 + 90];
        angle = MIN(angle, 360);
        chart.transformAngle = [[WQTransformCGFloat alloc] initWithFrom:chart.angle to:angle];
    }
    
    if ([keys containsObject:@"Rotation"]) {
        chart.transformRotation = [[WQTransformCGFloat alloc] initWithFrom:chart.rotation to:[NSNumber randomCGFloatFrom:0 to:360]];
    }
}

#pragma mark - AnimationDelegate

- (void)animation:(WQAnimation *)animation progressDidChange:(CGFloat)progress {
    [super animation:animation progressDidChange:progress];
    
    if (animation.transformable == self.radialChartView) {
        WQRadialChart* chart = self.radialChartView.chartAsRadial;
        [self updateSliderValue:chart.angle forKey:@"Angle" atIndex:0];
        [self updateSliderValue:chart.rotation forKey:@"Rotation" atIndex:0];
    }
    
}

@end
