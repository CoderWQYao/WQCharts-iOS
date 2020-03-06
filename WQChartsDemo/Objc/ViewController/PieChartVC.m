// 代码地址: 
// PieChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "PieChartVC.h"

@interface PieChartItemTag: NSObject

@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, strong) UIColor* gradientColor;
@property (nonatomic) BOOL separated;


@end

@implementation PieChartItemTag

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fillColor = UIColor.clearColor;
        self.gradientColor = UIColor.clearColor;
    }
    return self;
}

@end


@interface PieChartVC ()

@property (nonatomic, strong) NSArray<UIColor*>* colors;
@property (nonatomic, strong) WQPieChartView* chartView;

@end

@implementation PieChartVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartContainer addSubview:self.chartView];
    
    __weak typeof(self) weakSelf = self;
    
    ListCell* itemsCell = ListCell.new
    .setTitle(@"Items")
    .setIsMutable(YES)
    .setOnAppend(^void(ListCell* cell) {
        WQPieChartView* chartView = weakSelf.chartView;
        NSInteger index = chartView.chart.items.count;
        if(index >= weakSelf.colors.count) {
            return;
        }
        WQPieChartItem* item = [weakSelf createItemWithIndex:index];
        chartView.chart.items = [chartView.chart.items arrayByAddingObject:item];
        [weakSelf updateItemsText:chartView.chart.items];
        [chartView redraw];
        
        cell.addItem([weakSelf createCellWithItem:item]);
        [weakSelf scrollToListCellForKey:@"Items" atScrollPosition:ListViewScrollPositionBottom animated:YES];
    })
    .setOnRemove(^(ListCell* cell) {
        WQPieChartView* chartView = weakSelf.chartView;
        
        NSMutableArray<WQPieChartItem*>* items = [NSMutableArray arrayWithArray:chartView.chart.items];
        NSInteger index = items.count - 1;
        if(index < 0) {
            return;
        }
        cell.removeItemAtIndex(index);
        [weakSelf scrollToListCellForKey:@"Items" atScrollPosition:ListViewScrollPositionBottom animated:YES];
        
        [items removeObjectAtIndex:index];
        chartView.chart.items = items;
        [weakSelf updateItemsText:chartView.chart.items];
        [chartView redraw];
    });
    NSMutableArray<WQPieChartItem*>* items = [NSMutableArray array];
    for (NSInteger i=0; i<4; i++) {
        WQPieChartItem* item = [self createItemWithIndex:i];
        [items addObject:item];
        itemsCell.addItem([self createCellWithItem:item]);
    }
    [self updateItemsText:items];
    self.chartView.chart.items = items;
    [self.optionsView addItem:itemsCell];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsRing")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
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
     .setTitle(@"ItemsText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf updateItems];
    })];
    
    self.chartView.onGraphicItemClick = ^(WQPieChartView * _Nonnull chartView, WQPieGraphicItem * _Nonnull graphicItem) {
        WQPieChartItem* item = (WQPieChartItem*)graphicItem.builder;
        PieChartItemTag* tag = (PieChartItemTag*)item.tag;
        tag.separated = !tag.separated;
        item.offsetFactor = tag.separated ? 0.3 : 0;
        [chartView redraw];
    };
    
    [self callRadioCellsSectionChange];
}

- (NSArray<UIColor *> *)colors {
    if(!_colors) {
        _colors = Colors;
    }
    return _colors;
}

- (WQPieChartView *)chartView {
    if(!_chartView) {
        _chartView = [[WQPieChartView alloc] init];
    }
    return _chartView;
}

- (WQRadialChartView *)radialChartView {
    return self.chartView;
}

- (WQPieChartItem*)createItemWithIndex:(NSInteger)index {
    WQPieChartItem* item = [[WQPieChartItem alloc] initWithValue:1];
    
    PieChartItemTag* tag = [[PieChartItemTag alloc] init];
    if(index < self.colors.count) {
        tag.fillColor = self.colors[index];
        tag.gradientColor = self.colors[(index + 1) % self.colors.count];
    }
    item.tag = tag;
    
    WQChartText* text = [[WQChartText alloc] init];
    text.font = [UIFont systemFontOfSize:11];
    text.color = Color_White;
    item.text = text;
    [self updateItem:item];
    return item;
}

- (void)updateItem:(WQPieChartItem*)item {
    WQFillPaint* fillPaint = item.paint.fill;
    switch ([self radioCellSelectionForKey:@"ItemsFill"]) {
        case 1:
            fillPaint.color = ((PieChartItemTag*)item.tag).fillColor;
            fillPaint.shader = nil;
            break;
        case 2:
            fillPaint.color = nil;
            fillPaint.shader = ^id<Shader> _Nullable(WQFillPaint * _Nonnull paint, CGPathRef _Nonnull path, id _Nullable object) {
                WQPieGraphicItem* graphic = (WQPieGraphicItem*)object;
                WQPieChartItem* builder = (WQPieChartItem*)graphic.builder;
                PieChartItemTag* tag = builder.tag;
                return [[WQRadialGradientShader alloc] initWithCenterPoint:graphic.center radius:graphic.outerRadius colors:@[tag.gradientColor,tag.fillColor] positions:@[@0,@1]];
            };
            break;
        default:
            fillPaint.color = nil;
            fillPaint.shader = nil;
            break;
    }
    [self setupStrokePaint:item.paint.stroke color:Color_White type:[self radioCellSelectionForKey:@"ItemsStroke"]];
    
    item.innerFactor = [self radioCellSelectionForKey:@"ItemsRing"] != 0 ? 0.3 : 0;
    item.text.hidden = [self radioCellSelectionForKey:@"ItemsText"] == 0;
}

- (void)updateItems {
    NSArray<WQPieChartItem*>* items = self.chartView.chart.items;
    [self updateItemsText:items];
    for (WQPieChartItem* item in items) {
        [self updateItem:item];
    }
    [self.chartView redraw];
}

- (void)updateItemsText:(NSArray<WQPieChartItem*>*)items {
    float totalValue = [WQPieChartItem totalValueWithItems:items];
    for (WQPieChartItem* item in items) {
        item.text.string = [NSString stringWithFormat:@"%ld%%",(NSInteger)round((totalValue != 0 ? item.value / totalValue : 1) * 100)];
    }
}

- (SliderCell*)createCellWithItem:(WQPieChartItem*)item {
    __weak typeof(self) weakSelf = self;
    return SliderCell.new
    .setObject(item)
    .setSliderValue(0,1,item.value)
    .setDecimalCount(2)
    .setOnValueChange(^(SliderCell* cell, float value) {
        WQPieChartView* chartView = weakSelf.chartView;
        
        WQPieChartItem* item = (WQPieChartItem*)cell.object;
        item.value = value;
        [weakSelf updateItemsText:chartView.chart.items];
        [chartView redraw];
    });
}

@end
