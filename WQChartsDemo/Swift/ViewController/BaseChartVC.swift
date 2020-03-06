// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// BaseChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class BaseChartVC<T: UIView>: UIViewController {
    
    private var _chartView: T?
    open var chartView: T {
        if _chartView == nil {
            _chartView = T()
        }
        return _chartView!
    }
    
    lazy var optionsView: ListView = {
        let optionsView = ListView()
        optionsView.backgroundColor = Color_Block_Card
        return optionsView
    }()
    
    lazy var chartContainer: UIView = {
        let chartContainer = UIView()
        chartContainer.addSubview(chartView)
        return chartContainer
    }()
    
    deinit {
        print(self,#function)
    }
    
    override func viewDidLoad() {
        print(self,#function)
        
        super.viewDidLoad()
        self.view.backgroundColor = Color_Block_BG
        
        view.addSubview(optionsView)
        view.addSubview(chartContainer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        var contentInset: UIEdgeInsets = UIEdgeInsets()
        
        let optionsView = self.optionsView
        let optionsViewWidth = CGFloat(120)
        optionsView.frame = CGRect(x: width - optionsViewWidth, y: 0, width: optionsViewWidth, height: height)
        contentInset.right = optionsViewWidth
        
        let chartContainer = self.chartContainer
        chartContainer.frame = CGRect(x: contentInset.left, y: contentInset.top, width: width - contentInset.left - contentInset.right, height: height - contentInset.top - contentInset.bottom)
    }
    
    func setupStrokePaint(_ paint: LinePaint?, _ color: UIColor?, _ type: Int) {
        guard let paint = paint else {
            return
        }
        paint.color = color
        switch (type) {
        case 1:
            paint.width = 1
            paint.dashLengths = nil
            break
        case 2:
            paint.width = 1
            paint.dashLengths = [4,2]
            break
        default:
            paint.width = 0
            paint.dashLengths = nil
            break
        }
    }
    
    func findListCell(_ key: String) -> ListCell? {
        for cell in optionsView.items {
            guard let cell = cell as? ListCell else {
                continue
            }
            if key == cell.title {
                return cell
            }
        }
        return nil
    }
    
    func radioCellSelectionForKey(_ key: String) -> Int {
        for cell in optionsView.items {
            guard let cell = cell as? RadioCell else {
                continue
            }
            if key==cell.title {
                return cell.selection
            }
        }
        return 0
    }
    
    func updateSliderValue(_ key: String, _ index: Int, _ value: CGFloat) {
        guard let sliderListView = findListCell(key) else {
            return
        }
        guard let sliderCell = sliderListView.contentView.items[index] as? SliderCell else {
            return
        }
        sliderCell.value = value
    }
    
    func getSliderValue(_ key: String, _ index: Int) -> CGFloat {
        guard let sliderListView = findListCell(key) else {
            return 0
        }
        guard let sliderCell = sliderListView.contentView.items[index] as? SliderCell else {
            return 0
        }
        return sliderCell.value
    }
    
    func getSliderIntegerValue(_ key: String, _ index: Int) -> Int {
        guard let sliderListView = findListCell(key) else {
            return 0
        }
        guard let sliderCell = sliderListView.contentView.items[index] as? SliderCell else {
            return 0
        }
        return Int(round(sliderCell.value))
    }
    
    func scrollToListCell(_ key: String, _ scrollPosition: ListView.ScrollPosition, _ animated: Bool) {
        optionsView.setNeedsLayoutItems()
        guard let cell = findListCell(key) else {
            return
        }
        guard let index = optionsView.items.firstIndex(of: cell) else {
            return
        }
        optionsView.scrollToItem(index, scrollPosition, animated)
    }
    
    func callRadioCellsSectionChange() {
        for cell in optionsView.items {
            guard let radioCell = cell as? RadioCell else {
                continue
            }
            radioCell.callSectionChange()
        }
    }
    
    
}
