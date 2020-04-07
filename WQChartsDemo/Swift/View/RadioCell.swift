// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadioCell.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class RadioCell: ButtonsCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.style = .Radio
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func setTitle(_ title: String) -> RadioCell {
        self.title = title
        return self
    }
    
    open func setOptions(_ options: [String]?) -> RadioCell {
        self.options = options
        return self
    }
    
    open var selection: Int {
        get {
            for i in 0..<buttonsWrap.subviews.count {
                let button = buttonsWrap.subviews[i] as! UIButton
                if button.isSelected {
                    return i
                }
            }
            return 0
        }
        set {
            for i in 0..<buttonsWrap.subviews.count {
                let button = buttonsWrap.subviews[i] as! UIButton
                adjustButtonStyle(button, i == newValue)
            }
        }
    }
    
    open func setSelection(_ selection: Int) -> RadioCell {
        self.selection = selection
        return self
    }
    
    open var onSelectionChange: ((RadioCell, Int) -> Void)?
    
    open func setOnSelectionChange(_ onSelectionChange: ((RadioCell,Int) -> Void)?) -> RadioCell {
        self.onSelectionChange = onSelectionChange
        return self
    }
    
    open func callSectionChange() {
        if let onSelectionChange = onSelectionChange {
            onSelectionChange(self, selection)
        }
    }
    
    override func rebuildButtons() {
        let selection = self.selection
        
        super.rebuildButtons()
        
        let buttonsWrap = self.buttonsWrap
        for button in buttonsWrap.subviews as! [UIButton] {
            button.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        }
        
        var selectionChanged = false
        let buttonCount: Int = buttonsWrap.subviews.count
        if selection < 0 || selection > buttonCount - 1 {
            selectionChanged = true
        }
        
        if buttonCount > 0 {
            let button = buttonsWrap.subviews[selection] as! UIButton
            adjustButtonStyle(button, true)
        }
        
        if selectionChanged {
            callSectionChange()
        }
    }
    
    @objc func handleButtonClick(_ sender: UIButton) {
        if self.selection == self.buttonsWrap.subviews.firstIndex(of: sender) {
            return
        }
        
        for button in buttonsWrap.subviews {
            adjustButtonStyle(button as! UIButton, button == sender)
        }
        
        callSectionChange()
    }
    
}
