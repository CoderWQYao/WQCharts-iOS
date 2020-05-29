// https://github.com/CoderWQYao/WQCharts-iOS
//
// PolygonChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "PolygonChartVC.h"

@interface PolygonChartVC ()

@property (nonatomic, strong) WQPolygonChartView* chartView;
@property (nonatomic, strong) UIColor* currentColor;

@end

@implementation PolygonChartVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.currentColor = Color_Blue;
    }
    return self;
}

- (UIView *)createChartView {
    _chartView = [[WQPolygonChartView alloc] init];
    return _chartView;
}

- (void)configChartOptions {
    [super configChartOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Fill")
     .setOptions(@[@"OFF",@"ON",@"Gradient"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        WQPolygonChartView* chartView = strongSelf.chartView;
        WQChartFillPaint* paint = chartView.chart.paint.fill;
        switch (selection) {
            case 1: {
                paint.color = weakSelf.currentColor;
                paint.shader = nil;
                break;
            }
            case 2: {
                paint.color = nil;
                UIColor* color = strongSelf.currentColor;
                paint.shader = [[WQChartRadialGradient alloc] initWithCenter:CGPointMake(0.5, 0.5) radius:1 colors:@[[color colorWithAlphaComponent:0.1], color]];
                break;
            }
            default: {
                paint.color = nil;
                paint.shader = nil;
                break;
            }

        }
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Stoke")
     .setOptions(@[@"OFF",@"ON",@"Dash"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQPolygonChartView* chartView = weakSelf.chartView;
        
        [weakSelf setupStrokePaint:chartView.chart.paint.stroke color:Color_White type:selection];
        [chartView redraw];
    })];
    
}

#pragma mark - Items

- (void)configChartItemsOptions {
    [super configChartItemsOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsAxis")
     .setOptions(@[@"OFF",@"ON",@"Dash"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
}

- (NSMutableArray<WQPolygonChartItem*>*)items {
    NSArray<WQPolygonChartItem*>* items = self.chartView.chart.items;
    if (items) {
        return [NSMutableArray arrayWithArray:items];
    } else {
        NSMutableArray<WQPolygonChartItem*>* items = [NSMutableArray array];
        for (NSInteger i=0; i<5; i++) {
            WQPolygonChartItem* item = [self createItemAtIndex:i];
            [items addObject:item];
        }
        self.chartView.chart.items = items;
        return items;
    }
}

- (NSString*)itemsOptionTitle {
    return @"Items";
}

- (WQPolygonChartItem*)createItemAtIndex:(NSInteger)index {
    WQPolygonChartItem* item = [[WQPolygonChartItem alloc] initWithValue:0.5];
    
    WQChartText* text = [[WQChartText alloc] init];
    text.font = [UIFont systemFontOfSize:11];
    text.color = Color_White;
    WQChartTextBlocks* textBlocks = WQChartTextBlocks.new;
    textBlocks.offsetByAngle = ^CGFloat(WQChartText * _Nonnull chartText, CGSize size, CGFloat angle) {
        return 15;
    };
    text.delegateUsingBlocks = textBlocks;
    item.text = text;
    
    [self updateItem:item];
    return item;
}

- (SliderCell*)createItemCellWithItem:(WQPolygonChartItem*)item atIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    return SliderCell.new
    .setSliderValue(0,1,item.value)
    .setDecimalCount(2)
    .setObject(item)
    .setOnValueChange(^(SliderCell* cell,float value) {
        WQPolygonChartView* chartView = weakSelf.chartView;
        
        WQPolygonChartItem* item = (WQPolygonChartItem*)cell.object;
        item.value = value;
        [weakSelf updateItem:item];
        [chartView redraw];
    });
}

- (void)itemsDidChange:(NSMutableArray<WQPolygonChartItem*>*)items {
    self.chartView.chart.items = items;
    [self.chartView redraw];
}

- (void)updateItem:(WQPolygonChartItem*)item {
    [self setupStrokePaint:item.axisPaint color:Color_White type:[self radioCellSelectionForKey:@"ItemsAxis"]];
    item.text.hidden = [self radioCellSelectionForKey:@"ItemsText"] == 0;
}

- (void)updateItems {
    for (WQPolygonChartItem* item in self.chartView.chart.items) {
        [self updateItem:item];
    }
    [self.chartView redraw];
}

#pragma mark - ChartViewDrawDelegate

- (void)chartViewWillDraw:(WQChartView *)chartView inRect:(CGRect)rect context:(CGContextRef)context {
    [super chartViewWillDraw:chartView inRect:rect context:context];
    
    for (WQPolygonChartItem* item in self.chartView.chart.items) {
        item.text.string = [NSString stringWithFormat:@"%.2f",item.value];
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
    
    WQPolygonChart* chart = self.chartView.chart;
    
    if ([keys containsObject:@"Color"]) {
        UIColor* toColor = [self.currentColor isEqual:Color_Blue] ? Color_Red : Color_Blue;
        WQChartFillPaint* paint = chart.paint.fill;
        if (paint.color) {
            UIColor* color = paint.color;
            paint.colorTween = [[WQChartUIColorTween alloc] initWithFrom:color to:toColor];
        }
        if (paint.shader) {
            WQChartRadialGradient* shader = (WQChartRadialGradient*)paint.shader;
            shader.colorsTween = [[WQChartUIColorArrayTween alloc] initWithFrom:shader.colors to:@[[toColor colorWithAlphaComponent:0.1], toColor]];
        }
        self.currentColor = toColor;
    }
    
    if ([keys containsObject:@"Values"]) {
        [chart.items enumerateObjectsUsingBlock:^(WQPolygonChartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.valueTween = [[WQChartCGFloatTween alloc] initWithFrom:item.value to:[NSNumber randomCGFloatFrom:0 to:1]];
        }];
    }
    
}

#pragma mark - AnimationDelegate

- (void)animation:(WQChartAnimation *)animation progressDidChange:(CGFloat)progress {
    [super animation:animation progressDidChange:progress];

    if (animation.animatable == self.chartView) {
        [self.chartView.chart.items enumerateObjectsUsingBlock:^(WQPolygonChartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [self updateSliderValue:item.value forKey:@"Items" atIndex:idx];
        }];
    }

}

@end
