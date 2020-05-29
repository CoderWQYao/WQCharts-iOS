// https://github.com/CoderWQYao/WQCharts-iOS
//
// AreaChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "AreaChartVC.h"

@interface AreaChartVC ()

@property (nonatomic, strong) WQAreaChartView* chartView;
@property (nonatomic, strong) UIColor* currentColor;

@end

@implementation AreaChartVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.currentColor = Color_Blue;
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutRectangleChartView];
}

- (UIView *)createChartView {
    _chartView = [[WQAreaChartView alloc] init];
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
        WQAreaChartView* chartView = weakSelf.chartView;
        if(selection != 0) {
            chartView.chart.fixedMinY = @0;
            chartView.chart.fixedMaxY = @99;
        } else {
            chartView.chart.fixedMinY = nil;
            chartView.chart.fixedMaxY = nil;
        }
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Fill")
     .setOptions(@[@"OFF",@"ON",@"Gradient"])
     .setSelection(2)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateFillPaint];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Stoke")
     .setOptions(@[@"OFF",@"ON",@"Dash"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQAreaChartView* chartView = weakSelf.chartView;
        [weakSelf setupStrokePaint:chartView.chart.paint.stroke color:Color_White type:selection];
        [chartView redraw];
    })];
    
}

- (void)updateChartExchangeXY {
    [super updateChartExchangeXY];
    self.chartView.padding = [self chartViewPaddingForSelection:[self radioCellSelectionForKey:@"Padding"]];
    [self updateFillPaint];
    [self updateItems];
    [self.view setNeedsLayout];
}

- (void)updateFillPaint {
    NSInteger selection = [self radioCellSelectionForKey:@"Fill"];
    WQAreaChartView* chartView = self.chartView;
    WQAreaChart* chart = chartView.chart;
    WQChartFillPaint* paint = chart.paint.fill;
    switch (selection) {
        case 1: {
            paint.color = self.currentColor;
            paint.shader = nil;
            break;
        }
        case 2: {
            paint.color = nil;
            UIColor* color = self.currentColor;
            paint.shader = [[WQChartLinearGradient alloc] initWithStart:[chart convertRelativePointFromViewPoint:CGPointMake(0.5, 0)] end:[chart convertRelativePointFromViewPoint:CGPointMake(0.5, 1)] colors:@[[color colorWithAlphaComponent:0.1],color]];
            break;
        }
        default: {
            paint.color = nil;
            paint.shader = nil;
            break;
        }

    }
    [chartView redraw];
}


#pragma mark - Items

- (void)configChartItemsOptions {
    [super configChartItemsOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsHeaderText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsFooterText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
}

- (NSMutableArray<WQAreaChartItem*>*)items {
    NSArray<WQAreaChartItem*>* items = self.chartView.chart.items;
    if (items) {
        return [NSMutableArray arrayWithArray:items];
    } else {
        NSMutableArray<WQAreaChartItem*>* items = [NSMutableArray array];
        for (NSInteger i=0; i<5; i++) {
           WQAreaChartItem* item = [self createItemAtIndex:i];
           [items addObject:item];
        }
        self.chartView.chart.items = items;
        return items;
    }
}

- (NSString*)itemsOptionTitle {
    return @"Items";
}

- (WQAreaChartItem*)createItemAtIndex:(NSInteger)index {
    WQAreaChartItem* item = [[WQAreaChartItem alloc] initWithValue:CGPointMake(index, [NSNumber randomIntegerFrom:0 to:99])];
    
    WQChartText* headerText = [[WQChartText alloc] init];
    headerText.font = [UIFont systemFontOfSize:9];
    headerText.color = Color_White;
    item.headerText = headerText;
    
    WQChartText* footerText = [[WQChartText alloc] init];
    footerText.font = [UIFont systemFontOfSize:9];
    footerText.color = Color_White;
    item.footerText = footerText;
    
    [self updateItem:item];
    return item;
}

- (SliderCell*)createItemCellWithItem:(WQAreaChartItem*)item atIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    return SliderCell.new
    .setSliderValue(0,99,item.value.y)
    .setDecimalCount(0)
    .setObject(item)
    .setOnValueChange(^(SliderCell* cell,float value) {
        WQAreaChartItem* item = (WQAreaChartItem*)cell.object;
        item.value = CGPointMake(item.value.x, value);
        [weakSelf updateItem:item];
        [weakSelf.chartView redraw];
    });
}


- (void)itemsDidChange:(NSMutableArray<WQAreaChartItem*>*)items {
    self.chartView.chart.items = items;
    [self.chartView redraw];
}

- (void)updateItem:(WQAreaChartItem*)item {
    BOOL exchangeXY = self.chartView.chart.exchangeXY;
    
    WQChartText* headerText = item.headerText;
    if (headerText) {
        headerText.hidden = [self radioCellSelectionForKey:@"ItemsHeaderText"] == 0;
        WQChartTextBlocks* headerTextBlocks = WQChartTextBlocks.new;
        headerTextBlocks.offsetByAngle = ^CGFloat(WQChartText * _Nonnull chartText, CGSize size, CGFloat angle) {
            if (exchangeXY) {
                return 10;
            } else {
                return 10;
            }
        };
        headerText.delegateUsingBlocks = headerTextBlocks;
    }
    
    WQChartText* footerText = item.footerText;
    if (footerText) {
        footerText.hidden = [self radioCellSelectionForKey:@"ItemsFooterText"] == 0;
        WQChartTextBlocks* footerTextBlocks = WQChartTextBlocks.new;
        footerTextBlocks.offsetByAngle = ^CGFloat(WQChartText * _Nonnull chartText, CGSize size, CGFloat angle) {
            if (exchangeXY) {
                return 10;
            } else {
                return 10;
            }
        };
        footerText.delegateUsingBlocks = footerTextBlocks;
    }
    
}

- (void)updateItems {
    for (WQAreaChartItem* item in self.chartView.chart.items) {
        [self updateItem:item];
    }
    [self.chartView redraw];
}

#pragma mark - ChartViewDrawDelegate


- (void)chartViewWillDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    [super chartViewWillDraw:chartView inRect:rect context:context];
    
    for (WQAreaChartItem* item in self.chartView.chart.items) {
        NSString* string = [NSString stringWithFormat:@"%ld", (NSInteger)round(item.value.y)];
        item.headerText.string = string;
        item.footerText.string = string;
    }
}


- (void)appendAnimationKeys:(NSMutableArray<NSString *> *)animationKeys {
    [super appendAnimationKeys:animationKeys];
    [animationKeys addObject:@"Color"];
    [animationKeys addObject:@"Values"];
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    [super prepareAnimationOfChartViewForKeys:keys];
    
    WQAreaChart* chart = self.chartView.chart;
    
    if ([keys containsObject:@"Color"]) {
        UIColor* toColor = [self.currentColor isEqual:Color_Blue] ? Color_Red : Color_Blue;
        WQChartFillPaint* paint = chart.paint.fill;
        if (paint.color) {
            paint.colorTween = [[WQChartUIColorTween alloc] initWithFrom:paint.color to:toColor];
        }
        if (paint.shader) {
            WQChartLinearGradient* shader = (WQChartLinearGradient*)paint.shader;
            shader.colorsTween = [[WQChartUIColorArrayTween alloc] initWithFrom:shader.colors to:@[[toColor colorWithAlphaComponent:0.1],toColor]];
        }
        self.currentColor = toColor;
    }
    
    if ([keys containsObject:@"Values"]) {
        [self.chartView.chart.items enumerateObjectsUsingBlock:^(WQAreaChartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.valueTween = [[WQChartCGPointTween alloc] initWithFrom:item.value to:CGPointMake(item.value.x, [NSNumber randomIntegerFrom:0 to:99])];
        }];
    }
    
}

#pragma mark - AnimationDelegate

- (void)animation:(WQChartAnimation *)animation progressDidChange:(CGFloat)progress {
    [super animation:animation progressDidChange:progress];
    
    if (animation.animatable == self.chartView) {
        [self.chartView.chart.items enumerateObjectsUsingBlock:^(WQAreaChartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [self updateSliderValue:item.value.y forKey:@"Items" atIndex:idx];
        }];
    }
    
}

@end
