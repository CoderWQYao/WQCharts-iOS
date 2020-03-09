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

@property (nonatomic) CGFloat barWidth;
@property (nonatomic, strong) WQBarChartView* chartView;

@end

@implementation BarChartVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.barWidth = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartContainer addSubview:self.chartView];
    
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
    
    ListCell* itemsCell = ListCell.new
    .setTitle(@"Items")
    .setIsMutable(YES)
    .setOnAppend(^void(ListCell* cell) {
        WQBarChartView* chartView = weakSelf.chartView;
        
        NSInteger index = chartView.chart.items.count;
        WQBarChartItem* item = [weakSelf createItemWithX:index y:index % 2 == 0 ? 0.5 : -0.5];
        chartView.chart.items = [chartView.chart.items arrayByAddingObject:item];
        [chartView redraw];
        
        cell.addItem([weakSelf createCellWithItem:item]);
        [weakSelf scrollToListCellForKey:@"Items" atScrollPosition:ListViewScrollPositionBottom animated:YES];
    })
    .setOnRemove(^(ListCell* cell) {
        WQBarChartView* chartView = weakSelf.chartView;
        
        NSMutableArray<WQBarChartItem*>* items = [NSMutableArray arrayWithArray:chartView.chart.items];
        NSInteger index = items.count - 1;
        if(index < 0) {
            return;
        }
        cell.removeItemAtIndex(index);
        [weakSelf scrollToListCellForKey:@"Items" atScrollPosition:ListViewScrollPositionBottom animated:YES];
        
        [items removeObjectAtIndex:index];
        chartView.chart.items = items;
        [chartView redraw];
    });
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
        WQBarChartItem* item = [self createItemWithX:i y:y];
        [items addObject:item];
        itemsCell.addItem([self createCellWithItem:item]);
    }
    self.chartView.chart.items = items;
    [self.optionsView addItem:itemsCell];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsCornerRadius")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsStartValue")
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
    
    [self callRadioCellsSectionChange];
}

- (WQBarChartView *)chartView {
    if(!_chartView) {
        _chartView = [[WQBarChartView alloc] init];
    }
    return _chartView;
}

- (WQCoordinateChartView *)barLineChartView {
    return self.chartView;
}

- (WQBarChartItem*)createItemWithX:(CGFloat)x y:(CGFloat)y {
    WQBarChartItem* item = [[WQBarChartItem alloc] initWithX:x endY:y];
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

- (void)updateItem:(WQBarChartItem*)item {
    BOOL exchangeXY = [self radioCellSelectionForKey:@"ExchangeXY"] != 0;
    
    CGFloat cornerRadius = [self radioCellSelectionForKey:@"ItemsCornerRadius"] != 0 ? self.barWidth / 3 : 0;
    item.cornerRadius2 = cornerRadius;
    item.cornerRadius3 = cornerRadius;
    
    __block UIColor* fillColor;
    if([self radioCellSelectionForKey:@"ItemsStartValue"] != 0) {
        item.startY = @0;
        if(item.endY < 0) {
            fillColor = Color_Green;
        } else {
            fillColor = Color_Red;
        }
    } else {
        item.startY = nil;
        fillColor = Color_Red;
    }
    
    WQFillPaint* fillPaint = item.paint.fill;
    switch ([self radioCellSelectionForKey:@"ItemsFill"]) {
        case 1:
            fillPaint.color = fillColor;
            fillPaint.shader = nil;
            break;
        case 2: {
            fillPaint.color = nil;
            fillPaint.shader = ^id<Shader> _Nullable(WQFillPaint * _Nonnull paint, CGPathRef _Nonnull path, id _Nullable object) {
                WQBarGraphicItem* graphic = (WQBarGraphicItem*)object;
                return [[WQLinearGradientShader alloc] initWithStartPoint:graphic.stringStart endPoint:graphic.stringEnd colors:@[Color_Yellow,fillColor] positions:@[@0.0,@0.7]];
            };
            break;
        }
        default:
            fillPaint.color = nil;
            fillPaint.shader = nil;
            break;
    }
    
    [self setupStrokePaint:item.paint.stroke color:Color_White type:[self radioCellSelectionForKey:@"ItemsStroke"]];
    
    NSString* string = [NSString stringWithFormat:@"%.2f",item.endY];
    WQChartText* headerText = item.headerText;
    headerText.string = string;
    headerText.hidden = [self radioCellSelectionForKey:@"ItemsHeaderText"] == 0;
    headerText.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
        if(exchangeXY) {
            return 15;
        } else {
            return 10;
        }
    };
    
    WQChartText* footerText = item.footerText;
    footerText.string = string;
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

- (SliderCell*)createCellWithItem:(WQBarChartItem*)item {
    __weak typeof(self) weakSelf = self;
    return SliderCell.new
    .setSliderValue(-1,1,item.endY)
    .setDecimalCount(2)
    .setObject(item)
    .setOnValueChange(^(SliderCell* cell,float value) {
        WQBarChartView* chartView = weakSelf.chartView;
        
        WQBarChartItem* item = (WQBarChartItem*)cell.object;
        item.endY = value;
        [weakSelf updateItem:item];
        [chartView redraw];
    });
}

@end
