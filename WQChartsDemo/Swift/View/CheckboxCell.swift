// https://github.com/CoderWQYao/WQCharts-iOS
//
// CheckboxCell.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class CheckboxCell: ButtonsCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.style = .Checkbox
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open var selections: [Int] {
        get {
            let selections = NSMutableArray()
            for i in 0..<buttonsWrap.subviews.count {
                let button = buttonsWrap.subviews[i] as! UIButton
                if button.isSelected {
                    selections.add(i)
                }
            }
            return selections as! [Int]
        }
        set {
            for i in 0..<buttonsWrap.subviews.count {
                let button = buttonsWrap.subviews[i] as! UIButton
                adjustButtonStyle(button, false)
            }
            
            for selection in newValue {
                adjustButtonStyle(buttonsWrap.subviews[selection] as! UIButton, true)
            }
        }
    }
    
    
    open func setTitle(_ title: String) -> CheckboxCell {
        self.title = title
        return self
    }
    
    open func setOptions(_ options: [String]?) -> CheckboxCell {
        self.options = options
        return self
    }
    
    open func setSelections(_ selections: [Int]) -> CheckboxCell {
        self.selections = selections
        return self
    }
    
    open var onSelectionsChange: ((CheckboxCell, [Int]) -> Void)?
    
    open func setOnSelectionsChange(_ onSelectionsChange: ((CheckboxCell, [Int]) -> Void)?) -> CheckboxCell {
        self.onSelectionsChange = onSelectionsChange
        return self
    }
    
    open func callSectionsChange() {
        if let onSelectionsChange = onSelectionsChange {
            onSelectionsChange(self, selections)
        }
    }
    
    override func rebuildButtons() {
        let selections = self.selections
        
        super.rebuildButtons()
        
        let buttonsWrap = self.buttonsWrap
        for button in buttonsWrap.subviews as! [UIButton] {
            button.addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        }
        
        var selectionsChanged = false
        let buttonCount: Int = buttonsWrap.subviews.count
        for i in 0..<selections.count {
            let selection = selections[i]
            if selection < 0 || selection > buttonCount - 1 {
                selectionsChanged = true
            } else {
                adjustButtonStyle(buttonsWrap.subviews[selection] as! UIButton, true)
            }
        }
        
        if selectionsChanged {
            callSectionsChange()
        }
    }
    
    @objc func handleButtonClick(_ sender: UIButton) {
        adjustButtonStyle(sender, !sender.isSelected)
        callSectionsChange()
    }
    
}
