// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// RadioCell.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class RadioCell: UIView {
    
    // MARK: - Property
    
    open lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textColor = Color_White
        return titleLabel
    }()
    
    open lazy var buttonsView: UIView = {
        let buttonsView = UIView()
        return buttonsView
    }()
    
    open var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
            setNeedsLayout()
        }
    }

    open func setTitle(_ title: String) -> RadioCell {
        self.title = title
        return self
    }
    
    open var options: [String]? {
        didSet {
            for button in buttonsView.subviews {
                button.removeFromSuperview()
            }
            
            guard let options = options else {
                return
            }
            
            let count: Int = options.count
            var selection = self.selection
            if selection < 0 || selection > count - 1 {
                selection = 0
            }
            
            for i in 0..<count {
                let option = options[i]
                let button = UIButton(type: .custom)
                button.tag = i
                button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                button.setTitleColor(Color_White, for: .normal)
                button.setTitle(option, for: .normal)
                button.layer.borderWidth = 1
                button.layer.borderColor = Color_White.cgColor
                adjustButton(button, i == selection)
                button.addTarget(self, action: #selector(handleButtonClick(_:)), for: .touchUpInside)
                buttonsView.addSubview(button)
            }
            
            if selection != self.selection {
                selection = self.selection
                callSectionChange()
            }
            
            setNeedsLayout()
        }
    }

    open func setOptions(_ options: [String]?) -> RadioCell {
        self.options = options
        return self
    }
    
    open var selection = Int(0) {
        didSet {
            selectButton(buttonsView.subviews[selection] as! UIButton)
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
    
    private var buttonHeight: CGFloat = 25
    private var buttonSpacing: CGFloat = 5
    
    
    // MARK: - Public
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
           
        addSubview(titleLabel)
        addSubview(buttonsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.bounds.width
        let height = self.bounds.height
        var offsetY: CGFloat = 10
        
        let titleLabel = self.titleLabel
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: CGFloat(10), y: offsetY, width: width - 20, height: titleLabel.bounds.height)
        offsetY = titleLabel.frame.maxY + 5
        
        let buttonsView = self.buttonsView
        buttonsView.frame = CGRect(x: 10, y: offsetY, width: width - 20, height: height - offsetY - 10)
        layoutButtonsView()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 10
        
        let titleLabel = self.titleLabel
        titleLabel.sizeToFit()
        height += titleLabel.bounds.height
        
        let buttonCount = buttonsView.subviews.count
        if buttonCount > 0 {
            let buttonRowCount = buttonCount / 2 + (buttonCount % 2 > 0 ? 1 : 0)
            height += CGFloat(buttonRowCount) * (buttonHeight + buttonSpacing)
        }
        
        height += 10
        return CGSize(width: size.width, height: min(height, size.height))
    }
    
    open func callSectionChange() {
        if let onSelectionChange = onSelectionChange {
            onSelectionChange(self, selection)
        }
    }

    
    // MARK: - Private
    
    func layoutButtonsView() {
        let buttonsView = self.buttonsView
        let buttonCount = buttonsView.subviews.count
        if buttonCount==0 {
            return
        }
        
        let width = buttonsView.bounds.width
        let buttonWidth: CGFloat = buttonCount > 1 ? (width - 5) / 2 : width
        let buttonHeight = self.buttonHeight
        let buttonSpacing = self.buttonSpacing
        for i in 0..<buttonCount {
            let button = buttonsView.subviews[i]
            let column = i % 2
            let row = i / 2
            button.frame = CGRect(x: CGFloat(column) * (buttonWidth + buttonSpacing), y: CGFloat(row) * (buttonHeight + buttonSpacing), width: buttonWidth, height: buttonHeight)
            button.layer.cornerRadius = buttonHeight / 5;
        }
    }
    
    @objc func handleButtonClick(_ sender: UIButton) {
        selectButton(sender)
    }
    
    func selectButton(_ button: UIButton) {
        for subview in buttonsView.subviews {
            adjustButton(subview as! UIButton,subview==button)
        }
          
        if self.selection != button.tag {
            self.selection = button.tag
            callSectionChange()
        }
    }
    
    func adjustButton(_ button: UIButton, _ isSelected: Bool) {
        button.isSelected = isSelected
        if isSelected {
            button.backgroundColor = Color_White
            button.setTitleColor(Color_Tint, for: .normal)
        } else {
            button.backgroundColor = nil
            button.setTitleColor(Color_White, for: .normal)
        }
    }
    
}
