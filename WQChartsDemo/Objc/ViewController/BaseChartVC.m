// https://github.com/CoderWQYao/WQCharts-iOS
//
// BaseChartVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "BaseChartVC.h"

@interface BaseChartVC()

@property (nonatomic, strong) UIView* chartViewRef;
@property (nonatomic, strong) UIView* chartContainer;
@property (nonatomic, strong) ListView* optionsView;
@property (nonatomic, strong) WQChartAnimationPlayer* animationPlayer;

@end

@implementation BaseChartVC

- (UIView *)chartContainer {
    if(!_chartContainer) {
        _chartContainer = UIView.new;
        [_chartContainer addSubview:self.chartViewRef];
    }
    return _chartContainer;
}

- (ListView *)optionsView {
    if(!_optionsView) {
        _optionsView = ListView.new;
        _optionsView.backgroundColor = Color_Block_Card;
    }
    return _optionsView;
}

- (UIView *)chartViewRef {
    if(!_chartViewRef) {
        _chartViewRef = [self createChartView];
        [self chartViewDidCreate:_chartViewRef];
    }
    return _chartViewRef;
}

- (NSTimeInterval)animationDuration {
    return [self sliderValueForKey:@"AnimDuration" atIndex:0];
}

- (id<WQChartInterpolator>)animationInterpolator {
    NSInteger selection = [self radioCellSelectionForKey:@"AnimInterpolator"];
    switch (selection) {
        case 1:
            return [[WQChartAccelerateInterpolator alloc] initWithFactor:2];
        case 2:
            return [[WQChartDecelerateInterpolator alloc] initWithFactor:2];
        default:
            return [[WQChartLinearInterpolator alloc] init];
    }
}


- (void)dealloc {
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_Block_BG;
    
    [self.view addSubview:self.optionsView];
    [self.view addSubview:self.chartContainer];
    
    [self configChartOptions];
    [self configChartItemsOptions];
    [self configAnimationOptions];
    [self callRadioCellsSectionChange];
    
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    
    UIScrollView* optionsView = self.optionsView;
    CGFloat optionsViewWidth = 120;    optionsView.frame = CGRectMake(width - optionsViewWidth, 0, optionsViewWidth, height);
    contentInset.right = optionsViewWidth;
    
    UIView* chartContainer = self.chartContainer;
    chartContainer.frame = CGRectMake(contentInset.left, contentInset.top, width - contentInset.left - contentInset.right, height - contentInset.top - contentInset.bottom);
    
}

- (UIView*)createChartView {
    return nil;
}


- (void)chartViewDidCreate:(UIView*)chartView {
    
}


- (void)configChartOptions {
    
}

#pragma mark - Items

- (void)configChartItemsOptions {
    if (![self conformsToProtocol:@protocol(ItemsOptionsDelegate)]) {
        return;
    }
    
    __weak id<ItemsOptionsDelegate> itemsOptionsDelegate = (id<ItemsOptionsDelegate>)self;
    __weak typeof(self) weakSelf = self;
    
    NSString* title = itemsOptionsDelegate.itemsOptionTitle;
    
    ListCell* itemsCell = ListCell.new
    .setTitle(title)
    .setIsMutable(YES)
    .setOnAppend(^void(ListCell* cell) {
        NSMutableArray* items = itemsOptionsDelegate.items;
        NSInteger index = items.count;
        
        id item = [itemsOptionsDelegate createItemAtIndex:index];
        if (item) {
            [items addObject:item];
            [itemsOptionsDelegate itemsDidChange:items];
            
            cell.addItem([itemsOptionsDelegate createItemCellWithItem:item atIndex:index]);
            [weakSelf scrollToListCellForKey:title atScrollPosition:ListViewScrollPositionBottom animated:YES];
        }
    })
    .setOnRemove(^(ListCell* cell) {
        NSMutableArray* items = itemsOptionsDelegate.items;
        NSInteger index = items.count - 1;
        if(index < 0) {
            return;
        }
        cell.removeItemAtIndex(index);
        [weakSelf scrollToListCellForKey:title atScrollPosition:ListViewScrollPositionBottom animated:YES];
        
        [items removeObjectAtIndex:index];
        [itemsOptionsDelegate itemsDidChange:items];
    });
    
    NSMutableArray* items = itemsOptionsDelegate.items;
    [items enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        itemsCell.addItem([itemsOptionsDelegate createItemCellWithItem:item atIndex:idx]);
    }];
    [self.optionsView addItem:itemsCell];
}


#pragma mark - Paint

- (void)setupStrokePaint:(WQChartLinePaint* _Nullable)paint color:(UIColor* _Nullable)color type:(NSInteger)type {
    paint.color = color;
    switch (type) {
        case 1:
            paint.width = 1;
            paint.dashLengths = nil;
            break;
        case 2:
            paint.width = 1;
            paint.dashLengths = @[@4,@2];
            break;
        default:
            paint.width = 0;
            paint.dashLengths = nil;
            break;
    }
}


#pragma mark - Cell

- (ListCell*)findListCellForKey:(NSString*)key {
    for (ListCell* cell in self.optionsView.items) {
        if([cell isKindOfClass:ListCell.class] && [key isEqualToString:cell.title]) {
            return cell;
        }
    }
    return nil;
}

- (RadioCell*)findRadioCellForKey:(NSString*)key {
    for (RadioCell* cell in self.optionsView.items) {
        if([cell isKindOfClass:RadioCell.class] && [key isEqualToString:cell.title]) {
            return cell;
        }
    }
    return nil;
}

- (NSInteger)radioCellSelectionForKey:(NSString*)key {
    return [self findRadioCellForKey:key].selection;
}

- (void)updateSliderValue:(CGFloat)value forKey:(NSString*)key atIndex:(NSUInteger)index {
    ListCell* listCell = [self findListCellForKey:key];
    if(!listCell) {
        return;
    }
    SliderCell* sliderCell = (SliderCell*)listCell.contentView.items[index];
    if(![sliderCell isKindOfClass:SliderCell.class]) {
        return;
    }
    sliderCell.value = value;
}

- (CGFloat)sliderValueForKey:(NSString*)key atIndex:(NSUInteger)index {
    ListCell* listCell = [self findListCellForKey:key];
    if(!listCell) {
        return 0;
    }
    SliderCell* sliderCell = (SliderCell*)listCell.contentView.items[index];
    if(![sliderCell isKindOfClass:SliderCell.class]) {
        return 0;
    }
    return sliderCell.value;
}

- (CGFloat)sliderIntegerValueForKey:(NSString*)key atIndex:(NSUInteger)index {
    CGFloat value = [self sliderValueForKey:key atIndex:index];
    return (NSInteger)round(value);
}

- (void)scrollToListCellForKey:(NSString*)key atScrollPosition:(ListViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [self.optionsView setNeedsLayoutItems];
    ListCell* cell = [self findListCellForKey:key];
    NSInteger index = [self.optionsView.items indexOfObject:cell];
    [self.optionsView scrollToItemAtIndex:index atScrollPosition:scrollPosition animated:animated];
}

- (void)callRadioCellsSectionChange {
    for (UIView* cell in self.optionsView.items) {
        if(![cell isKindOfClass:RadioCell.class]) {
            continue;
        }
        
        RadioCell* radioCell = (RadioCell*)cell;
        [radioCell callSectionChange];
    }
}

#pragma mark - Animation

- (void)configAnimationOptions {
    [self.optionsView addItem:
     ListCell.new
     .setTitle(@"AnimDuration")
     .addItem(
              SliderCell.new
              .setSliderValue(0,5,0.5)
              .setDecimalCount(2)
              )
     ];
    
    [self.optionsView addItem:
     RadioCell.new
     .setTitle(@"AnimInterpolator")
     .setOptions(@[@"Linear",@"Accelerate",@"Decelerate"])
     .setSelection(0)
     ];
    
    NSMutableArray<NSString*>* animationKeys = [NSMutableArray array];
    [self appendAnimationKeys:animationKeys];
    
    [self.optionsView addItem:CheckboxCell.new
     .setTitle(@"Animations")
     .setOptions(animationKeys)];
    
    ButtonsCell* animationButtonsCell = ButtonsCell.new;
    animationButtonsCell.options = @[@"PlayAnimation"];
    UIButton* playButton = animationButtonsCell.buttonsWrap.subviews.firstObject;
    [playButton addTarget:self action:@selector(handlePlayAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsView addItem:animationButtonsCell];
}

- (void)handlePlayAnimation {
    CheckboxCell* animationsCell = nil;
    
    for (CheckboxCell* cell in self.optionsView.items) {
        if ([cell isKindOfClass:CheckboxCell.class] && [@"Animations" isEqualToString:cell.title]) {
            animationsCell = cell;
            break;
        }
    }
    
    if (animationsCell == nil) {
        return;
    }
    
    NSMutableArray<NSString*>* keys = [NSMutableArray array];
    for (NSNumber* selection in animationsCell.selections) {
        [keys addObject:animationsCell.options[selection.integerValue]];
    }
    
    if (keys.count == 0) {
        return;
    }
    
    [self.animationPlayer clearAnimations];
    
    NSMutableArray<WQChartAnimation*>* animations = [NSMutableArray array];
    WQChartAnimation* chartViewAnimation = [[WQChartAnimation alloc] initWithAnimatable:(id<WQChartAnimatable>)self.chartViewRef duration:self.animationDuration interpolator:self.animationInterpolator];
    chartViewAnimation.delegate = self;
    [self prepareAnimationOfChartViewForKeys:keys];
    [animations addObject:chartViewAnimation];
    [self appendAnimationsInArray:animations forKeys:keys];
    
    if (!_animationPlayer) {
        _animationPlayer = [[WQChartAnimationPlayer alloc] initWithDisplayView:self.chartViewRef];;
    }
    
    [self.animationPlayer startAnimations:animations];
}

- (void)appendAnimationKeys:(NSMutableArray<NSString*>*)animationKeys {
    
}

- (void)prepareAnimationOfChartViewForKeys:(NSArray<NSString*>*)keys {
    
}

- (void)appendAnimationsInArray:(NSMutableArray<WQChartAnimation*>*)array forKeys:(NSArray<NSString*>*)keys {
    
}

#pragma mark - AnimationDelegate

- (void)animationDidStart:(WQChartAnimation *)animation {
    NSLog(@"%@ %@:", self, @"animationDidStart");
}

- (void)animationDidStop:(WQChartAnimation *)animation finished:(BOOL)finished {
    NSLog(@"%@ %@: finished: %d", self, @"animationDidStop", finished);
    if (animation.animatable == (id<WQChartAnimatable>)self.chartViewRef) {
        id clipRect = [self.chartViewRef valueForKey:@"clipRect"];
        if (clipRect) {
            NSLog(@"Set clipRect nil");
            [self.chartViewRef setValue:nil forKey:@"clipRect"];
        }
    }
    
}

- (void)animation:(WQChartAnimation *)animation progressWillChange:(CGFloat)progress {
    
}

- (void)animation:(WQChartAnimation *)animation progressDidChange:(CGFloat)progress {
    
}

@end
