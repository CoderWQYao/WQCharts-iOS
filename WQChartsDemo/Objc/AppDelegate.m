// https://github.com/CoderWQYao/WQCharts-iOS
//
// AppDelegate.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationBar* navigationBar = [UINavigationBar appearance];
    navigationBar.barTintColor = Color_Block_BG;
    navigationBar.tintColor = Color_White;
    navigationBar.shadowImage = UIImage.new;
    navigationBar.translucent = NO;
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName : Color_White};

    UIWindow* window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:MainVC.new];
    [window makeKeyAndVisible];
    self.window = window;
    
    return YES;
}


@end
