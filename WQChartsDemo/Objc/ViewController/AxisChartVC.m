// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
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

@end

@implementation AxisChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartContainer addSubview:self.chartView];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Padding")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQAxisChartView* chartView = weakSelf.chartView;
        CGFloat padding = selection != 0 ? 30 : 0;
        chartView.padding = UIEdgeInsetsMake(padding, padding, padding, padding);
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ExchangeXY")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQAxisChartView* chartView = weakSelf.chartView;
        chartView.chart.exchangeXY = selection != 0;
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ReverseX")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQAxisChartView* chartView = weakSelf.chartView;
        chartView.chart.reverseX = selection != 0;
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ReverseY")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQAxisChartView* chartView = weakSelf.chartView;
        chartView.chart.reverseY = selection != 0;
        [chartView redraw];
    })];
    
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"HorizontalItems")
     .addItem(SliderCell.new
              .setSliderValue(0,5,1)
              .setDecimalCount(0)
              .setOnValueChange(^(SliderCell* cell,float value) {
        [weakSelf reloadItems];
    }))];
    
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"VerticalItems")
     .addItem(SliderCell.new
              .setSliderValue(0,5,1)
              .setDecimalCount(0)
              .setOnValueChange(^(SliderCell* cell,float value) {
        [weakSelf reloadItems];
    }))];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsHeaderText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQAxisChartView* chartView = weakSelf.chartView;
        
        for (WQLineChartItem* item in chartView.chart.items) {
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
        
        for (WQLineChartItem* item in chartView.chart.items) {
            item.footerText.hidden = selection == 0;
        }
        [chartView redraw];
    })];
    
    [self reloadItems];
    [self callRadioCellsSectionChange];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIView* chartContainer = self.chartContainer;
    CGFloat width = chartContainer.bounds.size.width;
    CGFloat height = chartContainer.bounds.size.height;
    
    CGFloat chartViewSize = MIN(width, height);
    self.chartView.frame = CGRectMake((width - chartViewSize) / 2, (height - chartViewSize) / 2, chartViewSize, chartViewSize);
}

- (WQAxisChartView *)chartView {
    if(!_chartView) {
        _chartView = [[WQAxisChartView alloc] init];
    }
    return _chartView;
}

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
    WQChartText* headerText = item.headerText;
    headerText.string = [NSString stringWithFormat:@"%.f,%.f",item.start.x, item.start.y];
    
    headerText.hidden = [self radioCellSelectionForKey:@"ItemsHeaderText"] == 0;
    
    WQChartText* footerText = item.footerText;
    footerText.string = [NSString stringWithFormat:@"%.f,%.f",item.end.x, item.end.y];
    footerText.hidden = [self radioCellSelectionForKey:@"ItemsFooterText"] == 0;
}

- (void)reloadItems {
    NSMutableArray<WQAxisChartItem*>* items = [NSMutableArray array];
    
    NSInteger horizontalCount = [self sliderIntegerValueForKey:@"HorizontalItems" index:0];
    NSInteger verticalCount = [self sliderIntegerValueForKey:@"VerticalItems" index:0];
    
    for (NSInteger i=0; i<horizontalCount; i++) {
        WQAxisChartItem* item = [self createItemWithStart:CGPointMake(0, i) end:CGPointMake(verticalCount > 1 ? verticalCount - 1 : 1, i)];
        [items addObject:item];
    }
    
    for (NSInteger i=0; i<verticalCount; i++) {
        WQAxisChartItem* item = [self createItemWithStart:CGPointMake(i, 0) end:CGPointMake(i, horizontalCount > 1 ? horizontalCount - 1 : 1)];
        [items addObject:item];
    }
    
    self.chartView.chart.items = items;
    [self.chartView redraw];
}

@end
