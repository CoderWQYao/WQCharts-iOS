// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// BarLineChartVC.h
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "BaseChartVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BarLineChartVC : BaseChartVC

@property (nonatomic, readonly) WQCoordinateChartView* barLineChartView;

- (void)updateItems;

@end

NS_ASSUME_NONNULL_END
