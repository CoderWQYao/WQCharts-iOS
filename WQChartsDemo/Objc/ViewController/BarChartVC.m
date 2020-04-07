// https://github.com/CoderWQYao/WQCharts-iOS
//
// BarChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "BarChartVC.h"

@interface BarChartVC ()

@property (nonatomic, strong) WQBarChartView* chartView;
@property (nonatomic) CGFloat barWidth;
@property (nonatomic, strong) UIColor* currentColor;

@end

@implementation BarChartVC


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.barWidth = 10;
        self.currentColor = Color_Red;
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutRectangleChartView];
}

- (UIView *)createChartView {
    _chartView = [[WQBarChartView alloc] init];
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
        WQBarChartView* chartView = weakSelf.chartView;
        if(selection != 0) {
            chartView.chart.fixedMinY = @-1;
            chartView.chart.fixedMaxY = @1;
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
     .setTitle(@"ItemsCornerRadius")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsStartY")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsFill")
     .setOptions(@[@"OFF",@"ON",@"Gradient"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsStroke")
     .setOptions(@[@"OFF",@"ON",@"Dash"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsHeaderText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsFooterText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
}

- (NSString*)itemsOptionTitle {
    return @"Items";
}

- (NSMutableArray<WQBarChartItem*>*)items {
    NSArray<WQBarChartItem*>* items = self.chartView.chart.items;
    if (items) {
        return [NSMutableArray arrayWithArray:items];
    } else {
        NSMutableArray<WQBarChartItem*>* items = [NSMutableArray array];
        for (NSInteger i=0; i<4; i++) {
            CGFloat y;
            switch (i) {
                case 0:
                    y = 0.4;
                    break;
                case 1:
                    y = 0.8;
                    break;
                case 2:
                    y = -0.8;
                    break;
                case 3:
                    y = -0.4;
                    break;
                default:
                    y = 0;
                    break;
            }
            WQBarChartItem* item = [self createItemAtIndex:i];
            item.endY = y;
            [items addObject:item];
        }
        self.chartView.chart.items = items;
        return items;
    }
}

- (WQBarChartItem*)createItemAtIndex:(NSInteger)index {
    WQBarChartItem* item = [[WQBarChartItem alloc] init];
    item.x = index;
    item.endY = index % 2 == 0 ? 0.5 : -0.5;
    item.barWidth = self.barWidth;
    
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

- (SliderCell*)createItemCellWithItem:(WQBarChartItem*)item atIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    return SliderCell.new
    .setSliderValue(-1,1,item.endY)
    .setDecimalCount(2)
    .setObject(item)
    .setOnValueChange(^(SliderCell* cell,float value) {
        WQBarChartItem* item = (WQBarChartItem*)cell.object;
        item.endY = value;
        [weakSelf updateItem:item];
        [weakSelf.chartView redraw];
    });
}

- (void)itemsDidChange:(NSMutableArray*)items {
    self.chartView.chart.items = items;
    [self.chartView redraw];
}

- (void)updateItem:(WQBarChartItem*)item {
    BOOL exchangeXY = [self radioCellSelectionForKey:@"ExchangeXY"] != 0;
    
    CGFloat cornerRadius = [self radioCellSelectionForKey:@"ItemsCornerRadius"] != 0 ? self.barWidth / 3 : 0;
    item.cornerRadius2 = cornerRadius;
    item.cornerRadius3 = cornerRadius;
    
    if([self radioCellSelectionForKey:@"ItemsStartY"] != 0) {
        item.startY = @0;
    } else {
        item.startY = nil;
    }
    
    WQFillPaint* fillPaint = item.paint.fill;
    switch ([self radioCellSelectionForKey:@"ItemsFill"]) {
        case 1:
            fillPaint.color = self.currentColor;
            fillPaint.shader = nil;
            break;
        case 2: {
            fillPaint.color = self.currentColor;
            fillPaint.shader = ^id<Shader> _Nullable(WQFillPaint * _Nonnull paint, CGPathRef _Nonnull path, id _Nullable object) {
                WQBarGraphicItem* graphic = (WQBarGraphicItem*)object;
                return [[WQLinearGradientShader alloc] initWithStartPoint:graphic.stringStart endPoint:graphic.stringEnd colors:@[Color_Yellow, paint.color ?: UIColor.clearColor] positions:@[@0.0,@0.7]];
            };
            break;
        }
        default:
            fillPaint.color = nil;
            fillPaint.shader = nil;
            break;
    }
    
    [self setupStrokePaint:item.paint.stroke color:Color_White type:[self radioCellSelectionForKey:@"ItemsStroke"]];
    
    WQChartText* headerText = item.headerText;
    headerText.hidden = [self radioCellSelectionForKey:@"ItemsHeaderText"] == 0;
    headerText.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
        if(exchangeXY) {
            return 15;
        } else {
            return 10;
        }
    };
    
    WQChartText* footerText = item.footerText;
    footerText.hidden = [self radioCellSelectionForKey:@"ItemsFooterText"] == 0;
    footerText.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
        if(exchangeXY) {
            return 15;
        } else {
            return 10;
        }
    };
}

- (void)updateItems {
    for (WQBarChartItem* item in self.chartView.chart.items) {
        [self updateItem:item];
    }
    [self.chartView redraw];
}


#pragma mark - ChartViewDrawDelegate

- (void)chartViewWillDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    [super chartViewWillDraw:chartView inRect:rect context:context];
    
    for (WQBarChartItem* item in self.chartView.chart.items) {
        NSString* string = [NSString stringWithFormat:@"%.2f",item.endY];
        item.headerText.string = string;
        item.footerText.string = string;
    }
}

#pragma mark - Animation

- (void)appendAnimationKeys:(NSMutableArray<NSString *> *)animationKeys {
    [super appendAnimationKeys:animationKeys];
    [animationKeys addObject:@"Values"];
    [animationKeys addObject:@"Colors"];
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    [super prepareAnimationOfChartViewForKeys:keys];
    
    WQBarChart* chart = self.chartView.chart;
    
    if ([keys containsObject:@"Values"]) {
        for (WQBarChartItem* item in chart.items) {
            item.transformEndY = [[WQTransformCGFloat alloc] initWithFrom:item.endY to:[NSNumber randomCGFloatFrom:-1 to:1]];
        }
    }
    
    if ([keys containsObject:@"Colors"]) {
        UIColor* color = [self.currentColor isEqual:Color_Red] ? Color_Green : Color_Red;
        for (WQBarChartItem* item in chart.items) {
            WQFillPaint* paint = item.paint.fill;
            if(!paint) {
                continue;
            }
            paint.transformColor = [[WQTransformUIColor alloc] initWithFrom:paint.color ?: UIColor.clearColor to:color];
        }
        self.currentColor = color;
        
        RadioCell* cell = [self findRadioCellForKey:@"ItemsFill"];
        if (cell.selection == 0) {
            cell.selection = 1;
        }
    }
    
}

#pragma mark - AnimationDelegate

- (void)animation:(WQAnimation *)animation progressDidChange:(CGFloat)progress {
    [super animation:animation progressDidChange:progress];
    
    if (animation.transformable == self.chartView) {
        [self.chartView.chart.items enumerateObjectsUsingBlock:^(WQBarChartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [self updateSliderValue:item.endY forKey:@"Items" atIndex:idx];
        }];
    }
    
}

@end
