// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadarChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "RadarChartVC.h"

@interface RadarChartVC () <WQRadarChartDataSource>

@property (nonatomic, strong) NSArray<UIColor*>* colors;
@property (nonatomic, strong) WQRadarChartView* chartView;
@property (nonatomic, strong) NSMutableArray<WQRadarChartPolygon*>* polygons;

@end

@implementation RadarChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartContainer addSubview:self.chartView];
    
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
    
    ListCell* polygonsCell = ListCell.new
    .setTitle(@"Polygons")
    .setIsMutable(YES)
    .setOnAppend(^void(ListCell* cell) {
        NSInteger index = weakSelf.polygons.count;
        if(index >= weakSelf.colors.count) {
            return;
        }
        
        WQRadarChartView* chartView = weakSelf.chartView;
        
        WQRadarChartPolygon* polygon = [weakSelf createPolygonWithIndex:index];
        [weakSelf.polygons addObject:polygon];
        [chartView.chart setNeedsReloadPolygons];
        [chartView redraw];
        
        cell.addItem([weakSelf createPolygonCellWithPolygon:polygon index:index]);
        [weakSelf scrollToListCellForKey:@"Polygons" atScrollPosition:ListViewScrollPositionBottom animated:YES];
    })
    .setOnRemove(^(ListCell* cell) {
        WQRadarChartView* chartView = weakSelf.chartView;
        
        NSMutableArray<WQRadarChartPolygon*>* polygons = weakSelf.polygons;
        NSInteger index = polygons.count - 1;
        if(index < 0) {
            return;
        }
        cell.removeItemAtIndex(index);
        [polygons removeObjectAtIndex:index];
        [weakSelf scrollToListCellForKey:@"Polygons" atScrollPosition:ListViewScrollPositionBottom animated:YES];
        
        [chartView.chart setNeedsReloadPolygons];
        [chartView redraw];
    });
    NSMutableArray<WQRadarChartPolygon*>* polygons = self.polygons;
    for (NSInteger i=0; i<2; i++) {
        WQRadarChartPolygon* polygon = [self createPolygonWithIndex:i];
        [polygons addObject:polygon];
        polygonsCell.addItem([self createPolygonCellWithPolygon:polygon index:i]);
    }
    self.polygons = polygons;
    [self.optionsView addItem:polygonsCell];
    
    [self callRadioCellsSectionChange];
}

- (NSArray<UIColor *> *)colors {
    if(!_colors) {
        _colors = Colors;
    }
    return _colors;
}

- (WQRadarChartView *)chartView {
    if(!_chartView) {
        _chartView = [[WQRadarChartView alloc] init];
        _chartView.chart.dataSource = self;
    }
    return _chartView;
}

- (WQRadialChartView *)radialChartView {
    return self.chartView;
}

- (NSMutableArray<WQRadarChartPolygon *> *)polygons {
    if(!_polygons) {
        _polygons = [NSMutableArray array];
    }
    return _polygons;
}

- (WQRadarChartPolygon*)createPolygonWithIndex:(NSInteger)index {
    UIColor* color = index < self.colors.count ? self.colors[index] : UIColor.clearColor;
    WQPolygonChart* chart = [[WQPolygonChart alloc] init];
    chart.shapePaint.fill.color = [color colorWithAlphaComponent:0.5];
    chart.shapePaint.stroke = nil;
    chart.axisPaint = nil;
    return [[WQRadarChartPolygon alloc] initWithChart:chart];
}

- (SectionCell*)createPolygonCellWithPolygon:(WQRadarChartPolygon*)polygon index:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    return SectionCell.new
    .setObject(polygon)
    .setTitle([NSString stringWithFormat:@"Polygon%ld",index])
    .setOnReload(^(SectionCell* cell) {
        WQRadarChartPolygon* polygon = (WQRadarChartPolygon*)cell.objcect;
        polygon.needsReloadItems = YES;
        [weakSelf.chartView redraw];
    });
}


#pragma mark - WQRadarChartDataSource

- (NSInteger)numberOfIndicatorsInRadarChart:(WQRadarChart *)radarChart {
    return [self sliderIntegerValueForKey:@"IndicatorCount" index:0];
}

- (WQRadarChartIndicator *)radarChart:(WQRadarChart *)radarChart indicatorAtIndex:(NSInteger)index {
    WQRadarChartIndicator* indicator = [[WQRadarChartIndicator alloc] init];
    [self setupStrokePaint:indicator.paint color:Color_White type:[self radioCellSelectionForKey:@"IndicatorsLine"]];
    
    if([self radioCellSelectionForKey:@"IndicatorsText"] != 0) {
        WQChartText* text = [[WQChartText alloc] init];
        text.font = [UIFont systemFontOfSize:11];
        text.color = Color_White;
        text.string = [NSString stringWithFormat:@"I-%ld",index];
        text.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
            return 15;
        };
        indicator.text = text;
    }
    
    return indicator;
}

- (NSInteger)numberOfSegmentsInRadarChart:(WQRadarChart *)radarChart {
    return [self sliderIntegerValueForKey:@"SegmentCount" index:0];
}

- (WQRadarChartSegment *)radarChart:(WQRadarChart *)radarChart segmentAtIndex:(NSInteger)index {
    WQRadarChartSegment* segment = [[WQRadarChartSegment alloc] init];
    [self setupStrokePaint:segment.paint color:Color_White type:[self radioCellSelectionForKey:@"SegmentsLine"]];
    segment.shape = [self radioCellSelectionForKey:@"SegmentsShape"] != 0 ? WQRadarChartSegmentShapeArc : WQRadarChartSegmentShapePolygon;
    segment.value = 1.0 - 1.0 / [self numberOfSegmentsInRadarChart:radarChart] * index;
    return segment;
}

- (NSInteger)numberOfPolygonsInRadarChart:(WQRadarChart *)radarChart {
    return self.polygons.count;
}

- (WQRadarChartPolygon *)radarChart:(WQRadarChart *)radarChart polygontAtIndex:(NSInteger)index {
    return self.polygons[index];
}

- (WQPolygonChartItem *)radarChart:(WQRadarChart *)radarChart itemOfChartForPolygonAtIndexPath:(NSIndexPath *)indexPath {
    return [[WQPolygonChartItem alloc] initWithValue:arc4random() % 101 / 100.0];
}


@end
