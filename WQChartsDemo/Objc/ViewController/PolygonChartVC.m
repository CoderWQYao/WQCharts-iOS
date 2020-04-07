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
        WQPolygonChartView* chartView = weakSelf.chartView;
        WQFillPaint* paint = chartView.chart.paint.fill;
        switch (selection) {
            case 1:
                paint.color = weakSelf.currentColor;
                paint.shader = nil;
                break;
            case 2:
                paint.color = weakSelf.currentColor;
                paint.shader = ^id<Shader> _Nullable(WQFillPaint * _Nonnull paint, CGPathRef _Nonnull path, id _Nullable object) {
                    UIColor* color = paint.color;
                    if (!color) {
                        return nil;
                    }
                    WQPolygonGraphic* graphic = (WQPolygonGraphic*)object;
                    return [[WQRadialGradientShader alloc] initWithCenterPoint:graphic.center radius:graphic.pathRadius colors:@[[color colorWithAlphaComponent:0.1], color] positions:@[@0,@1]];
                };
                break;
            default:
                paint.color = nil;
                paint.shader = nil;
                break;
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
    text.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
        return 15;
    };
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
    
    if ([keys containsObject:@"Color"] && chart.paint.fill) {
        WQFillPaint* paint = chart.paint.fill;
        UIColor* color = [self.currentColor isEqual:Color_Blue] ? Color_Red : Color_Blue;
        paint.transformColor = [[WQTransformUIColor alloc] initWithFrom:paint.color ? paint.color : UIColor.clearColor to:color];
        self.currentColor = color;
        
        RadioCell* cell = [self findRadioCellForKey:@"Fill"];
        if (cell.selection == 0) {
            cell.selection = 1;
        }
    }
    
    if ([keys containsObject:@"Values"]) {
        for (WQPolygonChartItem* item in chart.items) {
            item.transformValue = [[WQTransformCGFloat alloc] initWithFrom:item.value to:[NSNumber randomCGFloatFrom:0 to:1]];
        }
    }
    
}

#pragma mark - AnimationDelegate

- (void)animation:(WQAnimation *)animation progressDidChange:(CGFloat)progress {
    [super animation:animation progressDidChange:progress];

    if (animation.transformable == self.chartView) {
        [self.chartView.chart.items enumerateObjectsUsingBlock:^(WQPolygonChartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [self updateSliderValue:item.value forKey:@"Items" atIndex:idx];
        }];
    }

}

@end
