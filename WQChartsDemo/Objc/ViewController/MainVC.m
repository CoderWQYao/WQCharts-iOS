// https://github.com/CoderWQYao/WQCharts-iOS
//
// MainVC.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "MainVC.h"
#import "PolygonChartVC.h"
#import "PieChartVC.h"
#import "RadarChartVC.h"
#import "AxisChartVC.h"
#import "BarChartVC.h"
#import "LineChartVC.h"
#import "AreaChartVC.h"
#import "BizChartVC.h"

@interface MainVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray<NSDictionary*>* datas;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"WQCharts";
    self.view.backgroundColor = Color_Block_BG;
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* data = self.datas[indexPath.row];
    NSString* cellID = NSStringFromClass(UITableViewCell.class);
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.backgroundColor = UIColor.clearColor;
    cell.contentView.backgroundColor = UIColor.clearColor;
    cell.textLabel.textColor = Color_White;
    cell.textLabel.text = data[@"title"];
    
    UIView* selectedBackgroundView = UIView.new;
    selectedBackgroundView.backgroundColor = Color_Block_Card;
    cell.selectedBackgroundView = selectedBackgroundView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary* data = self.datas[indexPath.row];
    Class vcClass = data[@"class"];
    UIViewController* vc = [[vcClass alloc] init];
    vc.title = data[@"title"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if(!_tableView) {
        UITableView* tableView = [[UITableView alloc] init];
        tableView.backgroundColor = UIColor.clearColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
    }
    return _tableView;
}

- (NSArray<NSDictionary *> *)datas {
    if(!_datas) {
        NSArray<NSDictionary*>* datas = @[
            @{@"title":@"PolygonChart",@"class":PolygonChartVC.class},
            @{@"title":@"PieChart",@"class":PieChartVC.class},
            @{@"title":@"RadarChart",@"class":RadarChartVC.class},
            @{@"title":@"AxisChart",@"class":AxisChartVC.class},
            @{@"title":@"BarChart",@"class":BarChartVC.class},
            @{@"title":@"LineChart",@"class":LineChartVC.class},
            @{@"title":@"AreaChart",@"class":AreaChartVC.class},
            @{@"title":@"BizChart",@"class":BizChartVC.class},
        ];
        _datas = datas;
    }
    return _datas;
}

@end
