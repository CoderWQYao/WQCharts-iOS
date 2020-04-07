// https://github.com/CoderWQYao/WQCharts-iOS
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

@interface BizChartVC () <WQTransformable>

@property (nonatomic, strong) WQBizChartView* chartView;

@property (nonatomic) CGFloat barWidth;
@property (nonatomic) CGFloat barWidthHalf;
@property (nonatomic) NSInteger dataCount;
@property (nonatomic) CGFloat maxDataValue;
@property (nonatomic) UIEdgeInsets clipToRectInset;

@property (nonatomic, strong) NSMutableArray<BizChartItem*>* items;
@property (nonatomic, strong) NSMutableArray<WQBarGraphic*>* barGraphics;
@property (nonatomic, strong) NSValue* touchLocation;

@property (nonatomic, strong) NSValue* clipRect;
@property (nonatomic, strong) WQTransformCGRect* transformClipRect;

@end

@implementation BizChartVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.barWidth = 5;
        self.barWidthHalf = self.barWidth / 2;
        self.dataCount = 1000;
        self.maxDataValue = 1000;
        self.clipToRectInset = UIEdgeInsetsMake(0, -self.barWidthHalf, 0, -self.barWidthHalf);
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.chartView.frame = self.chartContainer.bounds;
}

- (UIView *)createChartView {
    _chartView = [[WQBizChartView alloc] init];
    _chartView.adapter = self;
    _chartView.separatorWidth = 10;
    [_chartView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)]];
    return _chartView;
}

- (void)configChartOptions {
    [super configChartOptions];
    
    __weak typeof(self) weakSelf = self;
    
    [self.optionsView addItem:RadioCell.new
     .setTitle(@"Padding")
     .setOptions(@[@"OFF",@"ON"])
     .setSelection(1)
     .setOnSelectionChange(^(RadioCell* cell, NSInteger selection) {
        WQBizChartView* chartView = weakSelf.chartView;
        if(selection) {
            chartView.padding = UIEdgeInsetsMake(20, 15, 20, 15);
        } else {
            chartView.padding = UIEdgeInsetsZero;
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
    
}

#pragma mark - Items

- (void)configChartItemsOptions {
    [super configChartItemsOptions];
}

- (NSMutableArray<BizChartItem *> *)items {
    if(!_items) {
        NSMutableArray<BizChartItem*>* items = [NSMutableArray array];
        for (NSInteger i=0; i<1; i++) {
            BizChartItem* item = [self createItemAtIndex:i];
            [items addObject:item];
        }
        _items = items;
    }
    return _items;
}

- (NSString*)itemsOptionTitle {
    return @"Rows";
}

- (BizChartItem*)createItemAtIndex:(NSInteger)index {
    NSMutableArray<id<WQChart>>* charts = [NSMutableArray array];
    
    [charts addObject:[[WQAxisChart alloc] init]];
    [charts addObject:[[WQBarChart alloc] init]];
    
    WQLineChart* lineChart = [[WQLineChart alloc] init];
    lineChart.paint.color = Color_Red;
    [charts addObject:lineChart];
    
    WQLineChart* lineChart2 = [[WQLineChart alloc] init];
    lineChart2.paint.color = Color_Orange;
    [charts addObject:lineChart2];
    
    return [[BizChartItem alloc] initWithCharts:charts datas:[self createDatas]];
}

- (NSMutableArray<BizChartData*>*)createDatas {
    NSMutableArray<BizChartData*>* datas = [NSMutableArray array];
    for (NSInteger i=0; i<self.dataCount; i++) {
        BizChartData* data = [[BizChartData alloc] init];
        data.barValue = [NSNumber randomCGFloatFrom:0 to:self.maxDataValue];
        // 让线段不顶边
        NSInteger lineMinValue = self.maxDataValue * 0.2;
        NSInteger lineMaxValue = self.maxDataValue * 0.8;
        data.lineValue = [NSNumber randomCGFloatFrom:lineMinValue to:lineMaxValue];
        data.lineValue2 =[NSNumber randomCGFloatFrom:lineMinValue to:lineMaxValue];
        [datas addObject:data];
    }
    return datas;
}

- (SectionCell*)createItemCellWithItem:(BizChartItem*)item atIndex:(NSInteger)index {
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

- (void)itemsDidChange:(NSMutableArray*)items {
    [self.chartView reloadData];
}

#pragma mark - BizChartViewAdapter

- (NSInteger)numberOfRowsInBizChartView:(WQBizChartView *)bizChartView {
    return self.items.count;
}

- (WQBizChartViewRow *)bizChartView:(WQBizChartView *)bizChartView rowAtIndex:(NSInteger)index {
    CGFloat rowWidth = MIN(bizChartView.bounds.size.height, bizChartView.bounds.size.width) / 3;
    if([self radioCellSelectionForKey:@"DistributionMode"] != 0) {
        NSInteger visiableCount = (bizChartView.bounds.size.width - bizChartView.padding.left - bizChartView.padding.right) / (self.barWidth + 2);
        return [[WQFixedVisiableCountDistributionRow alloc] initWithWidth:rowWidth visiableCount:visiableCount itemCount:self.dataCount];
    } else {
        return [[WQFixedItemSpacingDistributionRow alloc] initWithWidth:rowWidth itemSpacing:self.barWidth + 2 itemCount:self.dataCount];
    }
}

- (void)bizChartView:(WQBizChartView *)bizChartView distributeRowForDistributionPath:(WQDistributionPath *)distributionPath atIndex:(NSInteger)index {
    BizChartItem* item = self.items[index];
    WQAxisChart* axisChart = (WQAxisChart*)item.charts[0];
    WQBarChart* barChart = (WQBarChart*)item.charts[1];
    WQLineChart* lineChart = (WQLineChart*)item.charts[2];
    WQLineChart* lineChart2 = (WQLineChart*)item.charts[3];
    
    NSArray<WQDistributionPathItem*>* distributionPathItems = distributionPath.items;
    NSInteger capacity = distributionPathItems.count;
    
    // Build Items
    CGFloat minValue = 0;
    CGFloat maxValue = 0;
    NSMutableArray<WQBarChartItem*>* barChartItems = [NSMutableArray arrayWithCapacity:capacity];
    NSMutableArray<WQLineChartItem*>* lineChartItems = [NSMutableArray arrayWithCapacity:capacity];
    NSMutableArray<WQLineChartItem*>* lineChartItems2 = [NSMutableArray arrayWithCapacity:capacity];
    for (NSInteger i=0; i<capacity; i++) {
        WQDistributionPathItem* distributionPathItem = distributionPathItems[i];
        BizChartData* data = item.datas[distributionPathItem.index];
        NSInteger location = distributionPathItem.location;
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
            chart.fixedMinX = @(distributionPath.lowerBound);
            chart.fixedMaxX = @(distributionPath.upperBound);
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
- (void)bizChartView:(WQBizChartView *)bizChartView drawRowAtIndex:(NSInteger)index inContext:(CGContextRef)context {
    WQBizChartViewRow* row = bizChartView.rows[index];
    CGRect rect = row.rect;
    
    BizChartItem* item = self.items[index];
    WQAxisChart* axisChart = (WQAxisChart*)item.charts[0];
    WQBarChart* barChart = (WQBarChart*)item.charts[1];
    WQLineChart* lineChart = (WQLineChart*)item.charts[2];
    WQLineChart* lineChart2 = (WQLineChart*)item.charts[3];
    
    WQAxisGraphic* axisGraphic = [axisChart drawGraphicInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(-0.5, -self.barWidthHalf - 0.5, -0.5, -self.barWidthHalf - 0.5))  context:context];
    
    BOOL clipToRect = [self radioCellSelectionForKey:@"ClipToRect"] != 0;
    if(clipToRect) {
        CGContextClipToRect(context, UIEdgeInsetsInsetRect(rect, self.clipToRectInset));
    }
    
    if (self.clipRect) {
        CGContextClipToRect(context, self.clipRect.CGRectValue);
    }
    
    WQBarGraphic* barGraphic = [barChart drawGraphicInRect:rect context:context];
    [self.barGraphics addObject:barGraphic];
    
    [lineChart drawGraphicInRect:rect context:context];
    [lineChart2 drawGraphicInRect:rect context:context];
    
    if(clipToRect || self.clipRect) {
        CGContextResetClip(context);
    }
    
    [axisChart drawTextForGraphic:axisGraphic inContext:context];
}

- (void)bizChartViewWillDraw:(WQBizChartView *)bizChartView inContext:(CGContextRef)context {
    self.barGraphics = [NSMutableArray arrayWithCapacity:bizChartView.rows.count];
}

- (void)bizChartViewDidDraw:(WQBizChartView *)bizChartView inContext:(CGContextRef)context {
    [self drawTouchFocusInContext:context];
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

- (void)drawTouchFocusInContext:(CGContextRef)context {
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
    WQBarGraphicItem* nearestBarGraphicItem = [firstBarGraphic findNearestItemAtPoint:touchLocation inRect:UIEdgeInsetsInsetRect(insideBarGraphic.rect, self.clipToRectInset)];
    WQBarChartItem* nearestBarItem = (WQBarChartItem*)nearestBarGraphicItem.builder;
    if(nearestBarGraphicItem==nil) {
        return;
    }
    
    CGContextSaveGState(context);
    
    CGRect bounds = self.chartView.bounds;
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

#pragma mark - Animation

- (void)appendAnimationKeys:(NSMutableArray<NSString *> *)animationKeys {
    [super appendAnimationKeys:animationKeys];
    [animationKeys addObject:@"Padding"];
    [animationKeys addObject:@"Clip"];
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    [super prepareAnimationOfChartViewForKeys:keys];
    
    WQBizChartView* chartView = self.chartView;
    
    if ([keys containsObject:@"Padding"]) {
        RadioCell* paddingCell = [self findRadioCellForKey:@"Padding"];
        UIEdgeInsets padding = paddingCell.selection == 0 ? UIEdgeInsetsMake(20, 15, 20, 15) : UIEdgeInsetsZero;
        chartView.transformPadding = [[WQTransformUIEdgeInsets alloc] initWithFrom:chartView.padding to:padding];
        paddingCell.selection = paddingCell.selection == 0 ? 1 : 0;
    }
    
}

- (void)appendAnimationsInArray:(NSMutableArray<WQAnimation *> *)array forKeys:(NSArray<NSString *> *)keys {
    [super appendAnimationsInArray:array forKeys:keys];
    
    WQBizChartView* chartView = self.chartView;
    
    if ([keys containsObject:@"Clip"]) {
        CGRect rect = chartView.bounds;
        BOOL isReversed = [NSNumber randomBOOL];
        if (isReversed) {
            self.transformClipRect = [[WQTransformCGRect alloc] initWithFrom:
                                           CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), 0, CGRectGetHeight(rect))
                                                                               to:
                                           CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
        } else {
            self.transformClipRect = [[WQTransformCGRect alloc] initWithFrom:
                                           CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), 0, CGRectGetHeight(rect))
                                                                               to:
                                           CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
        }
        [array addObject:[[WQAnimation alloc] initWithTransformable:self duration:self.animationDuration interpolator:self.animationInterpolator]];
    }
    
}

#pragma mark - Transformable

- (void)nextTransform:(CGFloat)progress {
    WQTransformCGRect* transformClipRect = self.transformClipRect;
    if (transformClipRect) {
        self.clipRect = [NSValue valueWithCGRect:[self.transformClipRect valueForProgress:progress]];
    }
}

- (void)clearTransforms {
    self.transformClipRect = nil;
    self.clipRect = nil;
}

#pragma mark - Action

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)gestureRecognizer  {
    UIGestureRecognizerState state = gestureRecognizer.state;
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        self.touchLocation = [NSValue valueWithCGPoint:[gestureRecognizer locationInView:gestureRecognizer.view]];
    } else {
        self.touchLocation = nil;
    }
    [self.chartView redraw];
}



@end
