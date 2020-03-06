// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// MainVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    lazy open var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy open var datas: [NSDictionary] = {
        let datas: [NSDictionary] = [
            ["title":"PolygonChart","class":PolygonChartVC.self],
            ["title":"PieChart","class":PieChartVC.self],
            ["title":"RadarChart","class":RadarChartVC.self],
            ["title":"AxisChart","class":AxisChartVC.self],
            ["title":"BarChart","class":BarChartVC.self],
            ["title":"LineChart","class":LineChartVC.self],
            ["title":"FlowChart","class":FlowChartVC.self],
        ]
        return datas
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "WQCharts"
        view.backgroundColor = Color_Block_BG
        view.addSubview(self.tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
      
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = datas[indexPath.row]
        let cellID = NSStringFromClass(UITableViewCell.self)
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell.init(style: .default, reuseIdentifier: cellID)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.textColor = Color_White
        cell.textLabel?.text = data["title"] as? String
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Color_Block_Card
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let data = datas[indexPath.row]
        let vcClass = data["class"] as! UIViewController.Type
        let vc = vcClass.init()
        vc.title = (data["title"] as! String)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: nil, style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

