// 代码地址: 
// PolygonChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "PolygonChartVC.h"

@interface PolygonChartVC ()

@property (nonatomic, strong) WQPolygonChartView* chartView;

@end

@implementation PolygonChartVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartContainer addSubview:self.chartView];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Fill")
     .setOptions(@[@"OFF",@"ON",@"Gradient"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQPolygonChartView* chartView = weakSelf.chartView;
        WQFillPaint* paint = chartView.chart.shapePaint.fill;
        switch (selection) {
            case 1:
                paint.color = Color_Blue;
                paint.shader = nil;
                break;
            case 2:
                paint.color = nil;
                paint.shader = ^id<Shader> _Nullable(WQFillPaint * _Nonnull paint, CGPathRef _Nonnull path, id _Nullable object) {
                    WQPolygonGraphic* graphic = (WQPolygonGraphic*)object;
                    return [[WQRadialGradientShader alloc] initWithCenterPoint:graphic.center radius:graphic.shapeRadius colors:@[[Color_Blue colorWithAlphaComponent:0.1],Color_Blue] positions:@[@0,@1]];
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
        
        [weakSelf setupStrokePaint:chartView.chart.shapePaint.stroke color:Color_White type:selection];
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Axis")
     .setOptions(@[@"OFF",@"ON",@"Dash"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQPolygonChartView* chartView = weakSelf.chartView;
        
        [weakSelf setupStrokePaint:chartView.chart.axisPaint color:Color_White type:selection];
        [chartView redraw];
    })];
    
    
    ListCell* itemsCell = ListCell.new
    .setTitle(@"Items")
    .setIsMutable(YES)
    .setOnAppend(^void(ListCell* cell) {
        WQPolygonChartView* chartView = weakSelf.chartView;
        
        WQPolygonChartItem* item = [weakSelf createItem];
        chartView.chart.items = [chartView.chart.items arrayByAddingObject:item];
        [chartView redraw];
        
        cell.addItem([weakSelf createCellWithItem:item]);
        [weakSelf scrollToListCellForKey:@"Items" atScrollPosition:ListViewScrollPositionBottom animated:YES];
    })
    .setOnRemove(^(ListCell* cell) {
        WQPolygonChartView* chartView = weakSelf.chartView;
        
        NSMutableArray<WQPolygonChartItem*>* items = [NSMutableArray arrayWithArray:chartView.chart.items];
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
    NSMutableArray<WQPolygonChartItem*>* items = [NSMutableArray array];
    for (NSInteger i=0; i<4; i++) {
        WQPolygonChartItem* item = [self createItem];
        [items addObject:item];
        itemsCell.addItem([self createCellWithItem:item]);
    }
    self.chartView.chart.items = items;
    [self.optionsView addItem:itemsCell];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ItemsText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQPolygonChartView* chartView = weakSelf.chartView;
        
        for (WQPolygonChartItem* item in chartView.chart.items) {
            item.text.hidden = selection == 0;
        }
        [chartView redraw];
    })];
    
    [self callRadioCellsSectionChange];
}

- (WQPolygonChartView *)chartView {
    if(!_chartView) {
        _chartView = [[WQPolygonChartView alloc] init];
    }
    return _chartView;
}

- (WQRadialChartView *)radialChartView {
    return self.chartView;
}

- (WQPolygonChartItem*)createItem {
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

- (void)updateItem:(WQPolygonChartItem*)item {
    WQChartText* text = item.text;
    text.string = [NSString stringWithFormat:@"%.2f",item.value];
    text.hidden = [self radioCellSelectionForKey:@"ItemsText"] == 0;
}

- (SliderCell*)createCellWithItem:(WQPolygonChartItem*)item {
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

@end
