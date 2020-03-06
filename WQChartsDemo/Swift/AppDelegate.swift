// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// AppDelegate.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = Color_Block_BG
        navigationBar.tintColor = Color_White
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = {[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : Color_White]}()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController.init(rootViewController: MainVC())
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    

}

