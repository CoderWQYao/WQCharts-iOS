// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "RadarChartVC.h"

@interface RadarChartVC () 

@property (nonatomic, strong) WQRadarChartView* chartView;
@property (nonatomic, strong) NSMutableArray<WQRadarChartPolygon*>* items;
@property (nonatomic, strong) NSArray<UIColor*>* colors;

@end

@implementation RadarChartVC

- (NSArray<UIColor *> *)colors {
    if(!_colors) {
        _colors = Colors;
    }
    return _colors;
}

- (UIView *)createChartView {
    _chartView = [[WQRadarChartView alloc] init];
    _chartView.chart.dataSource = self;
    return _chartView;
}

- (void)configChartOptions {
    [super configChartOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"IndicatorCount")
     .addItem(SliderCell.new
              .setSliderValue(0,10,5)
              .setOnValueChange(^(SliderCell* cell,float value) {
        WQRadarChartView* chartView = weakSelf.chartView;
        [chartView.chart setNeedsReloadIndicators];
        [chartView redraw];
    }))];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"IndicatorsLine")
     .setOptions(@[@"OFF",@"ON",@"Dash"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQRadarChartView* chartView = weakSelf.chartView;
        [chartView.chart setNeedsReloadIndicators];
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"IndicatorsText")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQRadarChartView* chartView = weakSelf.chartView;
        [chartView.chart setNeedsReloadIndicators];
        [chartView redraw];
    })];
    
    [self.optionsView addItem:ListCell.new
     .setTitle(@"SegmentCount")
     .addItem(SliderCell.new
              .setSliderValue(0,10,5)
              .setOnValueChange(^(SliderCell* cell,float value) {
        WQRadarChartView* chartView = weakSelf.chartView;
        [chartView.chart setNeedsReloadSegments];
        [chartView redraw];
    }))];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"SegmentsShape")
     .setOptions(@[@"Polygon",@"Arc"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQRadarChartView* chartView = weakSelf.chartView;
        [chartView.chart setNeedsReloadSegments];
        [chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"SegmentsLine")
     .setOptions(@[@"OFF",@"ON",@"Dash"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQRadarChartView* chartView = weakSelf.chartView;
        [chartView.chart setNeedsReloadSegments];
        [chartView redraw];
    })];
    
}

#pragma mark - Items

- (void)configChartItemsOptions {
    [super configChartItemsOptions];
}

- (NSMutableArray<WQRadarChartPolygon*>*)items {
    if(!_items) {
        NSMutableArray<WQRadarChartPolygon*>* items = [NSMutableArray array];
        for (NSInteger i=0; i<2; i++) {
            WQRadarChartPolygon* item = [self createItemAtIndex:i];
            if (item) {
                [items addObject:item];
            }
        }
        _items = items;
    }
    return _items;
}

- (NSString*)itemsOptionTitle {
    return @"Polygons";
}

- (WQRadarChartPolygon*)createItemAtIndex:(NSInteger)index {
    if (index >= self.colors.count) {
        return nil;
    }
    UIColor* color = self.colors[index];
    WQPolygonChart* chart = [[WQPolygonChart alloc] init];
    chart.paint.fill.color = [color colorWithAlphaComponent:0.5];
    chart.paint.stroke = nil;
    return [[WQRadarChartPolygon alloc] initWithChart:chart];
}

- (SectionCell*)createItemCellWithItem:(WQRadarChartPolygon*)item atIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    return SectionCell.new
    .setObject(item)
    .setTitle([NSString stringWithFormat:@"Polygon%ld",index])
    .setOnReload(^(SectionCell* cell) {
        WQRadarChartPolygon* polygon = (WQRadarChartPolygon*)cell.objcect;
        polygon.needsReloadItems = YES;
        [weakSelf.chartView redraw];
    });
}

- (void)itemsDidChange:(NSMutableArray*)items {
    [self.chartView.chart setNeedsReloadPolygons];
    [self.chartView redraw];
}

#pragma mark - RadarChartDataSource

- (NSInteger)numberOfIndicatorsInRadarChart:(WQRadarChart *)radarChart {
    return [self sliderIntegerValueForKey:@"IndicatorCount" atIndex:0];
}

- (WQRadarChartIndicator *)radarChart:(WQRadarChart *)radarChart indicatorAtIndex:(NSInteger)index {
    WQRadarChartIndicator* indicator = [[WQRadarChartIndicator alloc] init];
    [self setupStrokePaint:indicator.paint color:Color_White type:[self radioCellSelectionForKey:@"IndicatorsLine"]];
    
    if([self radioCellSelectionForKey:@"IndicatorsText"] != 0) {
        WQChartText* text = [[WQChartText alloc] init];
        text.font = [UIFont systemFontOfSize:11];
        text.color = Color_White;
        text.string = [NSString stringWithFormat:@"I-%ld",index];
        
        WQChartTextBlocks* textBlocks = WQChartTextBlocks.new;
        textBlocks.offsetByAngle = ^CGFloat(WQChartText * _Nonnull chartText, CGSize size, CGFloat angle) {
            return 15;
        };
        text.delegateUsingBlocks = textBlocks;
        
        indicator.text = text;
    }
    
    return indicator;
}

- (NSInteger)numberOfSegmentsInRadarChart:(WQRadarChart *)radarChart {
    return [self sliderIntegerValueForKey:@"SegmentCount" atIndex:0];
}

- (WQRadarChartSegment *)radarChart:(WQRadarChart *)radarChart segmentAtIndex:(NSInteger)index {
    WQRadarChartSegment* segment = [[WQRadarChartSegment alloc] init];
    [self setupStrokePaint:segment.paint color:Color_White type:[self radioCellSelectionForKey:@"SegmentsLine"]];
    segment.shape = [self radioCellSelectionForKey:@"SegmentsShape"] != 0 ? WQRadarChartSegmentShapeArc : WQRadarChartSegmentShapePolygon;
    segment.value = 1.0 - 1.0 / [self numberOfSegmentsInRadarChart:radarChart] * index;
    return segment;
}

- (NSInteger)numberOfPolygonsInRadarChart:(WQRadarChart *)radarChart {
    return self.items.count;
}

- (WQRadarChartPolygon *)radarChart:(WQRadarChart *)radarChart polygontAtIndex:(NSInteger)index {
    return self.items[index];
}

- (WQPolygonChartItem *)radarChart:(WQRadarChart *)radarChart itemOfChartForPolygonAtIndexPath:(NSIndexPath *)indexPath {
    WQPolygonChartItem* item = [[WQPolygonChartItem alloc] initWithValue:[NSNumber randomCGFloatFrom:0 to:1]];
    item.axisPaint = nil;
    return item;
}

#pragma mark - Animation

- (void)appendAnimationKeys:(NSMutableArray<NSString *> *)animationKeys {
    [super appendAnimationKeys:animationKeys];
    [animationKeys addObject:@"Values"];
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    [super prepareAnimationOfChartViewForKeys:keys];
    
    if ([keys containsObject:@"Values"]) {
        for (WQRadarChartPolygon* polygon in self.items) {
            for (WQPolygonChartItem* item in polygon.chart.items) {
                item.valueTween = [[WQChartCGFloatTween alloc] initWithFrom:item.value to:[NSNumber randomCGFloatFrom:0 to:1]	];
            }
        }
    }
    
}

@end
