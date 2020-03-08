// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// BizChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "BizChartVC.h"

@interface BizChartData: NSObject

@property (nonatomic) CGFloat lineValue;
@property (nonatomic) CGFloat lineValue2;
@property (nonatomic) CGFloat barValue;

@end

@implementation BizChartData

@end


@interface BizChartItem: NSObject

@property (nonatomic, strong) NSArray<id<WQChart>>* charts;
@property (nonatomic, strong) NSArray<BizChartData*>* datas;

@end

@implementation BizChartItem

- (instancetype)initWithCharts:(NSArray<id<WQChart>>*)charts datas:(NSArray<BizChartData*>*)datas
{
    self = [super init];
    if (self) {
        self.charts = charts;
        self.datas = datas;
    }
    return self;
}

@end

@interface BizChartVC () <WQBizChartViewAdapter>

@property (nonatomic) CGFloat barWidth;
@property (nonatomic) CGFloat barWidthHalf;
@property (nonatomic) NSInteger dataCount;
@property (nonatomic) CGFloat maxDataValue;
@property (nonatomic) UIEdgeInsets clipInset;

@property (nonatomic, strong) WQBizChartView* chartView;
@property (nonatomic, strong) NSMutableArray<BizChartItem*>* items;
@property (nonatomic, strong) NSMutableArray<WQBarGraphic*>* barGraphics;
@property (nonatomic, strong) NSValue* touchLocation;

@end

@implementation BizChartVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.barWidth = 4;
        self.barWidthHalf = self.barWidth / 2;
        self.dataCount = 1000;
        self.maxDataValue = 1000;
        self.clipInset = UIEdgeInsetsMake(0, -self.barWidthHalf, 0, -self.barWidthHalf);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartContainer addSubview:self.chartView];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Padding")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        if(selection) {
            weakSelf.chartView.padding = UIEdgeInsetsMake(20, 15, 20, 15);
        } else {
            weakSelf.chartView.padding = UIEdgeInsetsZero;
        }
    })];
    
    // 分布模式
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"DistributionMode")
     .setOptions(@[@"0",@"1"])
     .setSelection(0)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf.chartView reloadData];
    })];
    
    // 固定BoundsX，开启可以展示出更平滑的滚动效果
    // 如果不开启，适合FixedVisiableCountDistributionRow使用
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"FixedBoundsX")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf.chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"FixedBoundsY")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf.chartView redraw];
    })];
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"ClipToRect")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        [weakSelf.chartView redraw];
    })];
    
    ListCell* rowsCell = ListCell.new
    .setTitle(@"Rows")
    .setIsMutable(YES)
    .setOnAppend(^void(ListCell* cell) {
        BizChartItem* item = [weakSelf createItem];
        [weakSelf.items addObject:item];
        [(WQBizChartView*)weakSelf.chartView reloadData];
        
        cell.addItem([weakSelf createRowCellWithItem:item index:weakSelf.items.count - 1]);
        [weakSelf scrollToListCellForKey:@"Rows" atScrollPosition:ListViewScrollPositionBottom animated:YES];
    })
    .setOnRemove(^(ListCell* cell) {
        NSMutableArray<BizChartItem*>* items = weakSelf.items;
        NSInteger index = items.count - 1;
        if(index < 0) {
            return;
        }
        cell.removeItemAtIndex(index);
        [weakSelf scrollToListCellForKey:@"Rows" atScrollPosition:ListViewScrollPositionBottom animated:YES];
        
        [items removeObjectAtIndex:index];
        [weakSelf.chartView reloadData];
    });
    NSMutableArray<BizChartItem*>* items = self.items;
    for (NSInteger i=0; i<1; i++) {
        BizChartItem* item = [self createItem];
        [items addObject:item];
        rowsCell.addItem([self createRowCellWithItem:item index:i]);
    }
    [self.optionsView addItem:rowsCell];
    
    [self callRadioCellsSectionChange];
    [self.chartView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.chartView.frame = self.chartContainer.bounds;
}

- (WQBizChartView *)chartView {
    if(!_chartView) {
        _chartView = [[WQBizChartView alloc] init];
        _chartView.adapter = self;
        _chartView.separatorWidth = 10;
    }
    return _chartView;
}

- (NSMutableArray<BizChartItem *> *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (BizChartItem*)createItem {
    NSMutableArray<id<WQChart>>* charts = [NSMutableArray array];
    
    [charts addObject:[[WQAxisChart alloc] init]];
    [charts addObject:[[WQBarChart alloc] init]];
    
    WQLineChart* lineChart = [[WQLineChart alloc] init];
    lineChart.shapePaint = nil;
    lineChart.linePaint.color = Color_Red;
    [charts addObject:lineChart];
    
    WQLineChart* lineChart2 = [[WQLineChart alloc] init];
    lineChart2.shapePaint = nil;
    lineChart2.linePaint.color = Color_Orange;
    [charts addObject:lineChart2];
    
    return [[BizChartItem alloc] initWithCharts:charts datas:[self createDatas]];
}

- (NSMutableArray<BizChartData*>*)createDatas {
    NSMutableArray<BizChartData*>* datas = [NSMutableArray array];
    for (NSInteger i=0; i<self.dataCount; i++) {
        BizChartData* data = [[BizChartData alloc] init];
        data.barValue = arc4random() % ((NSInteger)self.maxDataValue + 1);
        // 让线段不顶边
        NSInteger lineMaxValue = self.maxDataValue * 0.8;
        data.lineValue = arc4random() % (lineMaxValue + 1) + (self.maxDataValue - lineMaxValue) / 2;
        data.lineValue2 = arc4random() % (lineMaxValue + 1) + (self.maxDataValue - lineMaxValue) / 2;
        [datas addObject:data];
    }
    return datas;
}

- (SectionCell*)createRowCellWithItem:(BizChartItem*)item index:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    return SectionCell.new
    .setObject(item)
    .setTitle([NSString stringWithFormat:@"Row%ld",index])
    .setOnReload(^(SectionCell* cell) {
        BizChartItem* item = (BizChartItem*)cell.objcect;
        item.datas = [weakSelf createDatas];
        [weakSelf.chartView redraw];
    });
}

- (NSArray<WQAxisChartItem*>*)createAxisChartItemsWithLowerBound:(CGFloat)lowerBound upperBound:(CGFloat)upperBound {
    NSMutableArray<WQAxisChartItem*>* items = [NSMutableArray array];
    
    // Horizontal Axis
    NSInteger horizontalCount = 5;
    CGFloat horizontalStep = (upperBound - lowerBound) / (horizontalCount - 1);
    for (NSInteger i=0; i<horizontalCount; i++) {
        WQAxisChartItem* item = [[WQAxisChartItem alloc] initWithStart:CGPointMake(0, i) end:CGPointMake(1, i)];
        item.paint.color = Color_White;
        WQChartText* text = [[WQChartText alloc] init];
        text.color = Color_White;
        text.font = [UIFont systemFontOfSize:9];
        text.textOffsetByAngle = ^CGFloat(WQChartText * _Nonnull text, CGSize size, CGFloat angle) {
            return -(size.width / 2) - 3;
        };
        text.string = [NSString stringWithFormat:@"%ld",(NSInteger)(round(i * horizontalStep) + lowerBound)];
        if(i==0) {
            text.textOffset = ^CGPoint(WQChartText * _Nonnull text, CGSize size, NSNumber * _Nullable angle) {
                return CGPointMake(0, -size.height / 2);
            };
        } else if(i==horizontalCount - 1) {
            text.textOffset = ^CGPoint(WQChartText * _Nonnull text, CGSize size, NSNumber * _Nullable angle) {
                return CGPointMake(0, size.height / 2);
            };
        } else {
            item.paint.dashLengths = @[@4,@2];
        }
        item.headerText = text;
        [items addObject:item];
    }
    
    // Vertical Axis
    {
        WQAxisChartItem* item = [[WQAxisChartItem alloc] initWithStart:CGPointMake(0, 0) end:CGPointMake(0, horizontalCount - 1)];
        item.paint.color = Color_White;
        [items addObject:item];
        
        item = [[WQAxisChartItem alloc] initWithStart:CGPointMake(1, 0) end:CGPointMake(1, horizontalCount - 1)];
        item.paint.color = Color_White;
        [items addObject:item];
    }
    
    return items;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)gestureRecognizer  {
    UIGestureRecognizerState state = gestureRecognizer.state;
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        self.touchLocation = [NSValue valueWithCGPoint:[gestureRecognizer locationInView:gestureRecognizer.view]];
    } else {
        self.touchLocation = nil;
    }
    [self.chartView redraw];
}


#pragma mark - BizChartViewAdapter

- (NSInteger)numberOfRowsInHorizontalBizChartView:(WQBizChartView *)BizChartView {
    return _items.count;
}

- (WQBizChartViewRow *)BizChartView:(WQBizChartView *)BizChartView rowAtIndex:(NSInteger)index {
    CGFloat rowWidth = MIN(BizChartView.bounds.size.height, BizChartView.bounds.size.width) / 3;
    if([self radioCellSelectionForKey:@"DistributionMode"] != 0) {
        NSInteger visiableCount = (BizChartView.bounds.size.width - BizChartView.padding.left - BizChartView.padding.right) / (self.barWidth + 2);
        return [[WQFixedVisiableCountDistributionRow alloc] initWithWidth:rowWidth visiableCount:visiableCount itemCount:self.dataCount];
    } else {
        return [[WQFixedItemSpacingDistributionRow alloc] initWithWidth:rowWidth itemSpacing:self.barWidth + 2 itemCount:self.dataCount];
    }
}

- (void)BizChartView:(WQBizChartView *)BizChartView distributionForRow:(WQBizDistribution*)distribution atIndex:(NSInteger)index {
    BizChartItem* item = self.items[index];
    WQAxisChart* axisChart = (WQAxisChart*)item.charts[0];
    WQBarChart* barChart = (WQBarChart*)item.charts[1];
    WQLineChart* lineChart = (WQLineChart*)item.charts[2];
    WQLineChart* lineChart2 = (WQLineChart*)item.charts[3];
    
    NSArray<WQBizDistributionItem*>* distributionItems = distribution.items;
    NSInteger capacity = distributionItems.count;
    
    // Build Items
    CGFloat minValue = 0;
    CGFloat maxValue = 0;
    NSMutableArray<WQBarChartItem*>* barChartItems = [NSMutableArray arrayWithCapacity:capacity];
    NSMutableArray<WQLineChartItem*>* lineChartItems = [NSMutableArray arrayWithCapacity:capacity];
    NSMutableArray<WQLineChartItem*>* lineChartItems2 = [NSMutableArray arrayWithCapacity:capacity];
    for (NSInteger i=0; i<capacity; i++) {
        WQBizDistributionItem* distributionItem = distributionItems[i];
        BizChartData* data = item.datas[distributionItem.index];
        NSInteger location = distributionItem.location;
        CGFloat barValue = data.barValue;
        CGFloat lineValue = data.lineValue;
        CGFloat lineValue2 = data.lineValue2;
        
        WQBarChartItem* barChartItem = [[WQBarChartItem alloc] initWithX:location endY:barValue];
        barChartItem.barWidth = self.barWidth;
        barChartItem.paint.fill.color = Color_Gray;
        barChartItem.paint.stroke = nil;
        [barChartItems addObject:barChartItem];
        
        [lineChartItems addObject:[[WQLineChartItem alloc] initWithValue:CGPointMake(location, lineValue)]];
        [lineChartItems2 addObject:[[WQLineChartItem alloc] initWithValue:CGPointMake(location, lineValue2)]];
        
        CGFloat itemMinValue = MIN(MIN(barValue, lineValue),lineValue2);
        CGFloat itemMaxValue = MAX(MAX(barValue, lineValue),lineValue2);
        if(i==0) {
            minValue = itemMinValue;
            maxValue = itemMaxValue;
        } else {
            minValue = MIN(minValue, itemMinValue);
            maxValue = MAX(maxValue, itemMaxValue);
        }
    }
    
    barChart.items = barChartItems;
    lineChart.items = lineChartItems;
    lineChart2.items = lineChartItems2;
    
    // Fix Bounds
    BOOL fixedBoundsX = [self radioCellSelectionForKey:@"FixedBoundsX"] != 0;
    BOOL fixedBoundsY = [self radioCellSelectionForKey:@"FixedBoundsY"] != 0;
    for (NSInteger i=1; i<item.charts.count; i++) {
        WQCoordinateChart* chart = (WQCoordinateChart*)item.charts[i];
        if(fixedBoundsX) {
            chart.fixedMinX = @(distribution.lowerBound);
            chart.fixedMaxX = @(distribution.upperBound);
        } else {
            chart.fixedMinX = nil;
            chart.fixedMaxX = nil;
        }
        
        if(fixedBoundsY) {
            chart.fixedMinY = @(0);
            chart.fixedMaxY = @(self.maxDataValue);
        } else {
            chart.fixedMinY = @(minValue);
            chart.fixedMaxY = @(maxValue);
        }
    }
    
    axisChart.items = [self createAxisChartItemsWithLowerBound:barChart.fixedMinY.doubleValue upperBound:barChart.fixedMaxY.doubleValue];
}


// 绘制的分布内容的Charts.Rect不建议改动，因为Items是按照Row.length来分布的，Rect则按照Row.width、Row.length、BizChartView.contentOffset算出。
// 需要显示上的调整修改BizChartView.padding、Axis.rect、Context.clip等即可
- (void)BizChartView:(WQBizChartView *)BizChartView drawRowAtIndex:(NSInteger)index inContext:(CGContextRef)context {
    WQBizChartViewRow* row = BizChartView.rows[index];
    CGRect rect = row.rect;
    
    BizChartItem* item = self.items[index];
    WQAxisChart* axisChart = (WQAxisChart*)item.charts[0];
    WQBarChart* barChart = (WQBarChart*)item.charts[1];
    WQLineChart* lineChart = (WQLineChart*)item.charts[2];
    WQLineChart* lineChart2 = (WQLineChart*)item.charts[3];
    
    WQAxisGraphic* axisGraphic = [axisChart drawGraphicInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(-0.5, -self.barWidthHalf - 0.5, -0.5, -self.barWidthHalf - 0.5))  context:context];
    
    BOOL clipToRect = [self radioCellSelectionForKey:@"ClipToRect"] != 0;
    if(clipToRect) {
        CGContextClipToRect(context, UIEdgeInsetsInsetRect(rect, self.clipInset));
    }
    
    WQBarGraphic* barGraphic = [barChart drawGraphicInRect:rect context:context];
    [self.barGraphics addObject:barGraphic];
    
    [lineChart drawGraphicInRect:rect context:context];
    [lineChart2 drawGraphicInRect:rect context:context];
    
    if(clipToRect) {
        CGContextResetClip(context);
    }
    
    [axisChart drawTextForGraphic:axisGraphic inContext:context];
}

- (void)BizChartViewWillDraw:(WQBizChartView *)BizChartView inContext:(CGContextRef)context {
    self.barGraphics = [NSMutableArray arrayWithCapacity:BizChartView.rows.count];
}

- (void)BizChartViewDidDraw:(WQBizChartView *)BizChartView inContext:(CGContextRef)context {
    if(self.touchLocation==nil || self.barGraphics.count==0) {
        return;
    }
    
    CGPoint touchLocation = self.touchLocation.CGPointValue;
    WQBarGraphic* insideBarGraphic = nil;
    for (WQBarGraphic* barGraphic in self.barGraphics) {
        if(CGRectContainsPoint(barGraphic.rect, CGPointMake(CGRectGetMidX(barGraphic.rect), touchLocation.y))) {
            insideBarGraphic = barGraphic;
            break;
        }
    }
    if(insideBarGraphic == nil) {
        return;
    }
    
    WQBarGraphic* firstBarGraphic = self.barGraphics.firstObject;
    WQBarGraphicItem* nearestBarGraphicItem = [firstBarGraphic findNearestItemAtPoint:touchLocation inRect:UIEdgeInsetsInsetRect(insideBarGraphic.rect, self.clipInset)];
    WQBarChartItem* nearestBarItem = (WQBarChartItem*)nearestBarGraphicItem.builder;
    if(nearestBarGraphicItem==nil) {
        return;
    }
    
    CGContextSaveGState(context);
    
    CGRect bounds = BizChartView.bounds;
    CGFloat stringX = nearestBarGraphicItem.stringStart.x;
    
    CGContextMoveToPoint(context, stringX, CGRectGetMinY(bounds));
    CGContextAddLineToPoint(context, stringX, CGRectGetMaxY(bounds));
    CGContextMoveToPoint(context, CGRectGetMinX(bounds), touchLocation.y);
    CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), touchLocation.y);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, Color_White.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary<NSAttributedStringKey, id> * stringAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:Color_White,NSParagraphStyleAttributeName:paragraphStyle};
    
    NSString* horizontalString = [NSString stringWithFormat:@"X:%.2f",nearestBarItem.x];
    CGSize horizontalStringSize = [horizontalString sizeWithAttributes:stringAttributes];
    CGRect horizontalStringRect = CGRectMake(stringX - horizontalStringSize.width / 2 - 5, CGRectGetMinY(bounds), horizontalStringSize.width + 10, horizontalStringSize.height);
    if(CGRectGetMinX(horizontalStringRect) < CGRectGetMinX(bounds)) {
        horizontalStringRect.origin.x = CGRectGetMinX(bounds);
    } else if(CGRectGetMaxX(horizontalStringRect) > CGRectGetMaxX(bounds)) {
        horizontalStringRect.origin.x = CGRectGetMaxX(bounds) - horizontalStringRect.size.width;
    }
    CGContextSetFillColorWithColor(context, Color_Tint.CGColor);
    CGContextFillRect(context, horizontalStringRect);
    [horizontalString drawInRect:horizontalStringRect withAttributes:stringAttributes];
    
    if(insideBarGraphic) {
        CGPoint verticalBoundsPoint = [insideBarGraphic convertRectPointToBounds:touchLocation];
        NSString* verticalString = [NSString stringWithFormat:@"Y:%.2f",verticalBoundsPoint.y];
        CGSize verticalStringSize = [verticalString sizeWithAttributes:stringAttributes];
        CGRect verticalStringRect = CGRectMake(CGRectGetMinX(bounds), touchLocation.y - verticalStringSize.height / 2, verticalStringSize.width + 10, verticalStringSize.height);
        if(CGRectGetMinY(verticalStringRect) < CGRectGetMinY(bounds)) {
            verticalStringRect.origin.y = CGRectGetMinY(bounds);
        } else if(CGRectGetMaxY(verticalStringRect) > CGRectGetMaxY(bounds)) {
            verticalStringRect.origin.y = CGRectGetMaxY(bounds) - verticalStringRect.size.height;
        }
        CGContextSetFillColorWithColor(context, Color_Tint.CGColor);
        CGContextFillRect(context, verticalStringRect);
        [verticalString drawInRect:verticalStringRect withAttributes:stringAttributes];
    }
    
    CGContextRestoreGState(context);
}



@end
