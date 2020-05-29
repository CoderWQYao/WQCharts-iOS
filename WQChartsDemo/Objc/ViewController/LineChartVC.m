// https://github.com/CoderWQYao/WQCharts-iOS
//
// LineChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "LineChartVC.h"

@interface LineChartVC ()

@property (nonatomic, strong) WQLineChartView* chartView;
@property (nonatomic) UIColor* currentColor;

@end

@implementation LineChartVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.currentColor = Color_Blue;
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutRectangleChartView];
}

- (UIView *)createChartView {
    _chartView = [[WQLineChartView alloc] init];
    _chartView.chart.paint.color = self.currentColor;
    return _chartView;
}

- (void)configChartOptions {
    [super configChartOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"FixedBounds")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQLineChartView* chartView = weakSelf.chartView;
        if(selection != 0) {
            chartView.chart.fixedMinY = @0;
            chartView.chart.fixedMaxY = @99;
        } else {
            chartView.chart.fixedMinY = nil;
            chartView.chart.fixedMaxY = nil;
        }
        [chartView redraw];
    })];
    
}

- (void)updateChartExchangeXY {
    [super updateChartExchangeXY];
    self.chartView.padding = [self chartViewPaddingForSelection:[self radioCellSelectionForKey:@"Padding"]];
    [self updateItems];
    [self.view setNeedsLayout];
}

#pragma mark - Items

- (void)configChartItemsOptions {
    [super configChartItemsOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
}

- (NSMutableArray<WQLineChartItem*>*)items {
    NSArray<WQLineChartItem*>* items = self.chartView.chart.items;
    if (items) {
        return [NSMutableArray arrayWithArray:items];
    } else {
        NSMutableArray<WQLineChartItem*>* items = [NSMutableArray array];
        for (NSInteger i=0; i<5; i++) {
            WQLineChartItem* item = [self createItemAtIndex:i];
            [items addObject:item];
        }
        self.chartView.chart.items = items;
        return items;
    }
}

- (NSString*)itemsOptionTitle {
    return @"Items";
}

- (WQLineChartItem*)createItemAtIndex:(NSInteger)index {
    WQLineChartItem* item = [[WQLineChartItem alloc] initWithValue:CGPointMake(index, [NSNumber randomIntegerFrom:0 to:99])];
    
    WQChartText* headerText = [[WQChartText alloc] init];
    headerText.font = [UIFont systemFontOfSize:9];
    headerText.color = Color_White;
    item.text = headerText;
    
    [self updateItem:item];
    return item;
}

- (SliderCell*)createItemCellWithItem:(WQLineChartItem*)item atIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    return SliderCell.new
    .setSliderValue(0,99,item.value.y)
    .setDecimalCount(0)
    .setObject(item)
    .setOnValueChange(^(SliderCell* cell,float value) {
        WQLineChartItem* item = (WQLineChartItem*)cell.object;
        item.value = CGPointMake(item.value.x, value);
        [weakSelf updateItem:item];
        [weakSelf.chartView redraw];
    });
}

- (void)itemsDidChange:(NSMutableArray*)items {
    self.chartView.chart.items = items;
    [self.chartView redraw];
}

- (void)updateItem:(WQLineChartItem*)item {
    WQChartText* text = item.text;
    if (text) {
        text.hidden = [self radioCellSelectionForKey:@"ItemsText"] == 0;
    }
}

- (void)updateItems {
    for (WQLineChartItem* item in self.chartView.chart.items) {
        [self updateItem:item];
    }
    [self.chartView redraw];
}

#pragma mark - ChartViewDrawDelegate

- (void)chartViewWillDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    [super chartViewWillDraw:chartView inRect:rect context:context];
    
    for (WQLineChartItem* item in self.chartView.chart.items) {
        item.text.string = [NSString stringWithFormat:@"%ld", (NSInteger)round(item.value.y)];
    }
}

#pragma mark - Animation

- (void)appendAnimationKeys:(NSMutableArray<NSString *> *)animationKeys {
    [super appendAnimationKeys:animationKeys];
    [animationKeys addObject:@"Color"];
    [animationKeys addObject:@"Values"];
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    [super prepareAnimationOfChartViewForKeys:keys];
    
    WQLineChart* chart = self.chartView.chart;
    
    if ([keys containsObject:@"Color"]) {
        UIColor* toColor = [self.currentColor isEqual:Color_Blue] ? Color_Red : Color_Blue;
        WQChartLinePaint* paint = chart.paint;
        if (paint.color) {
            paint.colorTween = [[WQChartUIColorTween alloc] initWithFrom:paint.color to:toColor];
        }
        self.currentColor = toColor;
    }
    
    if ([keys containsObject:@"Values"]) {
        [self.chartView.chart.items enumerateObjectsUsingBlock:^(WQLineChartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.valueTween = [[WQChartCGPointTween alloc] initWithFrom:item.value to:CGPointMake(item.value.x, [NSNumber randomIntegerFrom:0 to:99])];
        }];
    }
    
}

#pragma mark - AnimationDelegate

- (void)animation:(WQChartAnimation *)animation progressDidChange:(CGFloat)progress {
    [super animation:animation progressDidChange:progress];
    
    if (animation.animatable == self.chartView) {
        [self.chartView.chart.items enumerateObjectsUsingBlock:^(WQLineChartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [self updateSliderValue:item.value.y forKey:@"Items" atIndex:idx];
        }];
    }

}

@end
