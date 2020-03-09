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

@end

@implementation LineChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartContainer addSubview:self.chartView];
    
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
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ShapeFill")
     .setOptions(@[@"OFF",@"ON",@"Gradient"])
     .setSelection(2)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQLineChartView* chartView = weakSelf.chartView;
        WQFillPaint* paint = chartView.chart.shapePaint.fill;
        switch (selection) {
            case 1:
                paint.color = Color_Blue;
                paint.shader = nil;
                break;
            case 2:
                paint.color = nil;
                paint.shader = ^id<Shader> _Nullable(WQFillPaint * _Nonnull paint, CGPathRef _Nonnull path, id _Nullable object) {
                    WQLineGraphic* graphic = (WQLineGraphic*)object;
                    return [[WQLinearGradientShader alloc] initWithStartPoint:graphic.stringStart endPoint:graphic.stringEnd colors:@[[Color_Blue colorWithAlphaComponent:0.1],Color_Blue] positions:@[@0,@1]];
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
     .setTitle(@"ShapeStoke")
     .setOptions(@[@"OFF",@"ON",@"Dash"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQLineChartView* chartView = weakSelf.chartView;
        [weakSelf setupStrokePaint:chartView.chart.shapePaint.stroke color:Color_White type:selection];
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"LinePaint")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQLineChartView* chartView = weakSelf.chartView;
        
        chartView.chart.linePaint.color = selection != 0 ? Color_Red : UIColor.clearColor;
        [chartView redraw];
    })];
    
    ListCell* itemsCell = ListCell.new
    .setTitle(@"Items")
    .setIsMutable(YES)
    .setOnAppend(^void(ListCell* cell) {
        WQLineChartView* chartView = weakSelf.chartView;
        
        WQLineChartItem* item = [weakSelf createItemWithIndex:chartView.chart.items.count];
        chartView.chart.items = [chartView.chart.items arrayByAddingObject:item];
        [chartView redraw];
        
        cell.addItem([weakSelf createCellWithItem:item]);
        [weakSelf scrollToListCellForKey:@"Items" atScrollPosition:ListViewScrollPositionBottom animated:YES];
    })
    .setOnRemove(^(ListCell* cell) {
        WQLineChartView* chartView = weakSelf.chartView;
        
        NSMutableArray<WQLineChartItem*>* items = [NSMutableArray arrayWithArray:chartView.chart.items];
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
    NSMutableArray<WQLineChartItem*>* items = [NSMutableArray array];
    for (NSInteger i=0; i<5; i++) {
        WQLineChartItem* item = [self createItemWithIndex:i];
        [items addObject:item];
        itemsCell.addItem([self createCellWithItem:item]);
    }
    self.chartView.chart.items = items;
    [self.optionsView addItem:itemsCell];
    
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
    
    [self callRadioCellsSectionChange];
}

- (WQLineChartView *)chartView {
    if(!_chartView) {
        _chartView = [[WQLineChartView alloc] init];
    }
    return _chartView;
}

- (WQCoordinateChartView *)barLineChartView {
    return self.chartView;
}

- (WQLineChartItem*)createItemWithIndex:(NSInteger)index {
    WQLineChartItem* item = [[WQLineChartItem alloc] initWithValue:CGPointMake(index, arc4random() % 100)];
    
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

- (void)updateItem:(WQLineChartItem*)item {
    BOOL exchangeXY = [self radioCellSelectionForKey:@"ExchangeXY"] != 0;
    
    NSString* string = [NSString stringWithFormat:@"%ld",(NSInteger)item.value.y];
    
    WQChartText* headerText = item.headerText;
    headerText.string = string;
    headerText.hidden = [self radioCellSelectionForKey:@"ItemsHeaderText"] == 0;
    headerText.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
        if(exchangeXY) {
            return 10;
        } else {
            return 10;
        }
    };
    
    WQChartText* footerText = item.footerText;
    footerText.string = string;
    footerText.hidden = [self radioCellSelectionForKey:@"ItemsFooterText"] == 0;
    footerText.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
        if(exchangeXY) {
            return 10;
        } else {
            return 10;
        }
    };
}

- (void)updateItems {
    for (WQLineChartItem* item in self.chartView.chart.items) {
        [self updateItem:item];
    }
    [self.chartView redraw];
}

- (SliderCell*)createCellWithItem:(WQLineChartItem*)item {
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


@end
