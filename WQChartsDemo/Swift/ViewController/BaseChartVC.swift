// https://github.com/CoderWQYao/WQCharts-iOS
//
// BaseChartVC.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

protocol ItemsOptionsDelegate: UIViewController {
    
    var items: NSMutableArray { get }
    var itemsOptionTitle: String { get }

    func createItem(atIndex index: Int) -> Any?
    func createItemCell(withItem item: Any, atIndex index: Int)  -> UIView
    
    func itemsDidChange(_ items: NSMutableArray)

}

class BaseChartVC<T: UIView>: UIViewController, ChartAnimationDelegate {
    
    lazy open var chartView: T = {
        let chartView = T()
        chartViewDidCreate(chartView)
        return chartView
    }()
    
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
    
    weak var itemsOptionsDelegate: ItemsOptionsDelegate?
    
    var animationPlayer: ChartAnimationController?
    
    var animationDuration: TimeInterval {
        return TimeInterval(sliderValue(forKey: "AnimDuration", atIndex: 0))
    }
    
    var animationInterpolator: ChartInterpolator {
        let selection = radioCellSelectionForKey("AnimInterpolator")
        switch selection {
        case 1:
            return ChartAccelerateInterpolator(2)
        case 2:
            return ChartDecelerateInterpolator(2)
        default:
            return ChartLinearInterpolator()
        }
    }

    deinit {
        print(self,#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color_Block_BG
        
        view.addSubview(optionsView)
        view.addSubview(chartContainer)
        
        configChartOptions()
        configChartItemsOptions()
        configAnimationOptions()
        callRadioCellsSectionChange()
        
        print(self,#function)
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
    
    func chartViewDidCreate(_ chartView: T) {
        
    }
    
    func configChartOptions() {
        
    }
    
    // MARK: - Items
    
    func configChartItemsOptions() {
        guard let itemsOptionsDelegate = self as? ItemsOptionsDelegate else {
            return
        }
        
        let title = itemsOptionsDelegate.itemsOptionTitle
        let itemsCell = ListCell()
            .setTitle(title)
            .setIsMutable(true)
            .setOnAppend({[weak self, weak itemsOptionsDelegate](cell) in
                guard let self = self, let itemsOptionsDelegate = itemsOptionsDelegate else {
                    return
                }
                
                let items = itemsOptionsDelegate.items
                let index = items.count
                
                if let item = itemsOptionsDelegate.createItem(atIndex: index) {
                    items.add(item)
                    itemsOptionsDelegate.itemsDidChange(items)
                    
                    cell.addItem(itemsOptionsDelegate.createItemCell(withItem: item, atIndex: index))
                    self.scrollToListCell(title, .Bottom, true)
                }
            }).setOnRemove({[weak self, weak itemsOptionsDelegate](cell) in
                guard let self = self, let itemsOptionsDelegate = itemsOptionsDelegate else {
                    return
                }
                
                let items = itemsOptionsDelegate.items
                let index = items.count - 1
                if index < 0 {
                    return
                }
                
                cell.removeItem(at: index)
                self.scrollToListCell(title, .Bottom, true)
                
                items.removeObject(at: index)
                itemsOptionsDelegate.itemsDidChange(items)
            })
        
        let items = itemsOptionsDelegate.items
        items.enumerateObjects { (item, idx, stop) in
            itemsCell.addItem(itemsOptionsDelegate.createItemCell(withItem: item, atIndex: idx))
        }
        optionsView.addItem(itemsCell)
        
    }
    
    // MARK: - Paint
    
    func setupStrokePaint(_ paint: ChartLinePaint?, _ color: UIColor?, _ type: Int) {
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
    
    
    // MARK: - Cell
    
    func findListCellForKey(_ key: String) -> ListCell? {
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
    
    
    func findRadioCellForKey(_ key: String) -> RadioCell? {
        for cell in optionsView.items {
            guard let cell = cell as? RadioCell else {
                continue
            }
            if key == cell.title {
                return cell
            }
        }
        return nil
    }
    
    func radioCellSelectionForKey(_ key: String) -> Int {
        return findRadioCellForKey(key)?.selection ?? 0
    }
    
    func updateSliderValue(_ value: CGFloat, forKey key: String, atIndex index: Int) {
        guard let sliderListView = findListCellForKey(key) else {
            return
        }
        guard let sliderCell = sliderListView.contentView.items[index] as? SliderCell else {
            return
        }
        sliderCell.value = value
    }
    
    func sliderValue(forKey key: String, atIndex index: Int) -> CGFloat {
        guard let sliderListView = findListCellForKey(key) else {
            return 0
        }
        guard let sliderCell = sliderListView.contentView.items[index] as? SliderCell else {
            return 0
        }
        return sliderCell.value
    }
    
    func sliderIntegerValue(forKey key: String, atIndex index: Int) -> Int {
        guard let sliderListView = findListCellForKey(key) else {
            return 0
        }
        guard let sliderCell = sliderListView.contentView.items[index] as? SliderCell else {
            return 0
        }
        return Int(round(sliderCell.value))
    }
    
    func scrollToListCell(_ key: String, _ scrollPosition: ListView.ScrollPosition, _ animated: Bool) {
        optionsView.setNeedsLayoutItems()
        guard let cell = findListCellForKey(key) else {
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
    
    // MARK: - Animation
    
    func configAnimationOptions() {
        
        optionsView.addItem(
            ListCell()
                .setTitle("AnimDuration")
                .addItem(
                    SliderCell()
                        .setSliderValue(0,5,0.5)
                        .setDecimalCount(2)
            )
        )
        
        optionsView.addItem(
            RadioCell()
                .setTitle("AnimInterpolator")
                .setOptions(["Linear","Accelerate","Decelerate"])
                .setSelection(0)
        )
        
        let animationKeys = NSMutableArray()
        appendAnimationKeys(animationKeys)
        
        optionsView.addItem(CheckboxCell()
            .setTitle("Animations")
            .setOptions((animationKeys as! [String])))
        
        let animationButtonsCell = ButtonsCell()
        animationButtonsCell.options = ["PlayAnimation"]
        let playButton = animationButtonsCell.buttonsWrap.subviews.first as! UIButton
        playButton.addTarget(self, action:#selector(handlePlayAnimation), for: .touchUpInside)
        optionsView.addItem(animationButtonsCell)
    }
    
    func appendAnimationKeys(_ animationKeys: NSMutableArray) {
        
    }
    
    @objc func handlePlayAnimation() {
        var animationsCell_op: CheckboxCell?
        for cell in optionsView.items {
            guard let cell = cell as? CheckboxCell else {
                continue
            }
            if "Animations" == cell.title {
                animationsCell_op = cell
                break
            }
        }
        
        guard let animationsCell = animationsCell_op else {
            return
        }
        
        let keys = NSMutableArray()
        for selection in animationsCell.selections {
            keys.add(animationsCell.options![selection])
        }
        
        if keys.count == 0 {
            return
        }
        
        animationPlayer?.clearAnimations()
        
        let animations = NSMutableArray()
        let chartViewAnimation = ChartAnimation(self.chartView as! ChartAnimatable, animationDuration, animationInterpolator)
        chartViewAnimation.delegate = self
        prepareAnimationOfChartView(forKeys: keys as! [String])
        animations.add(chartViewAnimation)
        appendAnimations(inArray: animations, forKeys: keys as! [String])
        
        if animationPlayer == nil {
            animationPlayer = ChartAnimationController(displayView: self.chartView)
        }
        animationPlayer?.startAnimations(animations as! [ChartAnimation])
    }
    
    func prepareAnimationOfChartView(forKeys keys: [String]) {
        
    }
    
    func appendAnimations(inArray array: NSMutableArray, forKeys keys: [String]) {
        
    }
    
    // MARK: - AnimationDelegate
    
    func animationDidStart(_ animation: ChartAnimation) {
        print(self, "animationDidStart:")
    }
    
    func animationDidStop(_ animation: ChartAnimation, finished: Bool) {
        print(self, "animationDidStop:finished:",finished)
        if chartView.isEqual(animation.animatable) {
            let clipRect = chartView.value(forKey: "clipRect")
            if clipRect != nil {
                print("Set clipRect nil");
                chartView.setValue(nil, forKey: "clipRect")
            }
        }
    }
    
    func animation(_ animation: ChartAnimation, progressWillChange progress: CGFloat) {
        
    }
    
    func animation(_ animation: ChartAnimation, progressDidChange progress: CGFloat) {
        
    }
    
}
