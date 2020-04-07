// https://github.com/CoderWQYao/WQCharts-iOS
//
// AxisChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "AxisChartVC.h"

@interface AxisChartVC ()

@property (nonatomic, strong) WQAxisChartView* chartView;
@property (nonatomic, strong) NSMutableArray<WQAxisChartItem*>* horizontalItems;
@property (nonatomic, strong) NSMutableArray<WQAxisChartItem*>* verticalItems;

@end

@implementation AxisChartVC

- (NSMutableArray<WQAxisChartItem *> *)horizontalItems {
    if(!_horizontalItems) {
        _horizontalItems = [NSMutableArray array];
    }
    return _horizontalItems;
}

- (NSMutableArray<WQAxisChartItem *> *)verticalItems {
    if(!_verticalItems) {
        _verticalItems = [NSMutableArray array];
    }
    return _verticalItems;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UIView* chartContainer = self.chartContainer;
    CGFloat width = chartContainer.bounds.size.width;
    CGFloat height = chartContainer.bounds.size.height;
    CGFloat fitSize = MIN(width, height);
    self.chartView.frame = CGRectMake((width - fitSize) / 2, (height - fitSize) / 2, fitSize, fitSize);
}

- (UIView *)createChartView {
    _chartView = [[WQAxisChartView alloc] init];
    return _chartView;
}

- (void)configChartOptions {
    [super configChartOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"HorizontalItems")
     .addItem(SliderCell.new
              .setSliderValue(0,5,1)
              .setDecimalCount(0)
              .setOnValueChange(^(SliderCell* cell,float value) {
        [weakSelf resetItems];
    }))];
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"VerticalItems")
     .addItem(SliderCell.new
              .setSliderValue(0,5,1)
              .setDecimalCount(0)
              .setOnValueChange(^(SliderCell* cell,float value) {
        [weakSelf resetItems];
    }))];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsHeaderText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQAxisChartView* chartView = weakSelf.chartView;
        for (WQAxisChartItem* item in chartView.chart.items) {
            item.headerText.hidden = selection == 0;
        }
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsFooterText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQAxisChartView* chartView = weakSelf.chartView;
        for (WQAxisChartItem* item in chartView.chart.items) {
            item.footerText.hidden = selection == 0;
        }
        [chartView redraw];
    })];
    
    [self resetItems];
}

- (UIEdgeInsets)chartViewPaddingForSelection:(NSInteger)selection {
    CGFloat padding = selection != 0 ? 30 : 0;
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

#pragma mark - Items

- (WQAxisChartItem*)createItemWithStart:(CGPoint)start end:(CGPoint)end {
    WQAxisChartItem* item = [[WQAxisChartItem alloc] initWithStart:start end:end];
    [self setupStrokePaint:item.paint color:Color_White type:1];
    
    WQChartText* headerText = [[WQChartText alloc] init];
    headerText.font = [UIFont systemFontOfSize:9];
    headerText.color = Color_White;
    headerText.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
        return 15;
    };
    item.headerText = headerText;
    
    WQChartText* footerText = [[WQChartText alloc] init];
    footerText.font = [UIFont systemFontOfSize:9];
    footerText.color = Color_White;
    footerText.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
        return 15;
    };
    item.footerText = footerText;
    
    [self updateItem:item];
    return item;
}

- (void)updateItem:(WQAxisChartItem*)item {
    item.headerText.hidden = [self radioCellSelectionForKey:@"ItemsHeaderText"] == 0;
    item.footerText.hidden = [self radioCellSelectionForKey:@"ItemsFooterText"] == 0;
}

- (void)resetItems {
    NSInteger horizontalCount = [self sliderIntegerValueForKey:@"HorizontalItems" atIndex:0];
    NSInteger verticalCount = [self sliderIntegerValueForKey:@"VerticalItems" atIndex:0];
    CGFloat maxX = verticalCount > 1 ? verticalCount - 1 : 1;
    CGFloat maxY = horizontalCount > 1 ? horizontalCount - 1 : 1;
    
    WQAxisChartView* chartView = self.chartView;
    chartView.chart.fixedMinX = @0;
    chartView.chart.fixedMaxX = @(maxX);
    chartView.chart.fixedMinY = @0;
    chartView.chart.fixedMaxY = @(maxY);
    
    NSMutableArray<WQAxisChartItem*>* horizontalItems = self.horizontalItems;
    [horizontalItems removeAllObjects];
    for (NSInteger i=0; i<horizontalCount; i++) {
        WQAxisChartItem* item = [self createItemWithStart:CGPointMake(0, i) end:CGPointMake(maxX, i)];
        [horizontalItems addObject:item];
    }
    
    NSMutableArray<WQAxisChartItem*>* verticalItems = self.verticalItems;
    [verticalItems removeAllObjects];
    for (NSInteger i=0; i<verticalCount; i++) {
        WQAxisChartItem* item = [self createItemWithStart:CGPointMake(i, 0) end:CGPointMake(i, maxY)];
        [verticalItems addObject:item];
    }
    
    NSMutableArray<WQAxisChartItem*>* items = [NSMutableArray arrayWithCapacity:horizontalCount + verticalCount];
    [items addObjectsFromArray:horizontalItems];
    [items addObjectsFromArray:verticalItems];
    chartView.chart.items = items;
    
    [chartView redraw];
}

#pragma mark - ChartViewDrawDelegate

- (void)chartViewWillDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    [super chartViewWillDraw:chartView inRect:rect context:context];
    
    for (WQAxisChartItem* item in self.chartView.chart.items) {
        item.headerText.string = [NSString stringWithFormat:@"%.f,%.f",item.start.x, item.start.y];
        item.footerText.string = [NSString stringWithFormat:@"%.f,%.f",item.end.x, item.end.y];
    }
}

- (void)appendAnimationKeys:(NSMutableArray<NSString *> *)animationKeys {
    [super appendAnimationKeys:animationKeys];
    [animationKeys addObject:@"Values"];
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    [super prepareAnimationOfChartViewForKeys:keys];
    
    WQAxisChartView* chartView = self.chartView;
    WQAxisGraphic* graphic = chartView.graphic;
    if ([keys containsObject:@"Values"] && graphic) {
        NSArray<WQAxisChartItem*>* horizontalItems = self.horizontalItems;
        for (NSInteger i=0; i<horizontalItems.count; i++) {
            WQAxisChartItem* item = horizontalItems[i];
            item.transformEnd = [[WQTransformCGPoint alloc] initWithFrom:item.start to:CGPointMake(CGRectGetMaxX(graphic.bounds), i)];
        }
        
        NSArray<WQAxisChartItem*>* verticalItems = self.verticalItems;
        for (NSInteger i=0; i<verticalItems.count; i++) {
            WQAxisChartItem* item = verticalItems[i];
            item.transformEnd = [[WQTransformCGPoint alloc] initWithFrom:item.start to:CGPointMake(i, CGRectGetMaxY(graphic.bounds))];
        }
    }
}

@end
