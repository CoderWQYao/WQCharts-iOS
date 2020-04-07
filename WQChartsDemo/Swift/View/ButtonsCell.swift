// https://github.com/CoderWQYao/WQCharts-iOS
//
// ButtonsCell.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class ButtonsCell: UIView {
    
    enum Style {
        case Normal,Radio,Checkbox
    }
    
    // MARK: - Property
    
    open lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textColor = Color_White
        return titleLabel
    }()
    
    open lazy var buttonsWrap: UIView = {
        let buttonsWrap = UIView()
        return buttonsWrap
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
    
    open var options: [String]? {
        didSet {
            rebuildButtons()
        }
    }
    
    open var style: Style = .Normal {
        didSet {
            rebuildButtons()
        }
    }
    
    private var buttonHeight: CGFloat = 25
    private var buttonSpacing: CGFloat = 5
    
    // MARK: - Public
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(buttonsWrap)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        
        let buttonsWrap = self.buttonsWrap
        buttonsWrap.frame = CGRect(x: 10, y: offsetY, width: width - 20, height: height - offsetY - 10)
        layoutButtons()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 10
        
        let titleLabel = self.titleLabel
        titleLabel.sizeToFit()
        height += titleLabel.bounds.height
        
        let buttonCount = buttonsWrap.subviews.count
        if buttonCount > 0 {
            let buttonRowCount = buttonCount / 2 + (buttonCount % 2 > 0 ? 1 : 0)
            height += CGFloat(buttonRowCount) * (buttonHeight + buttonSpacing)
        }
        
        height += 10
        return CGSize(width: size.width, height: min(height, size.height))
    }
    
    // MARK: - Internal
    
    func rebuildButtons() {
        for button in buttonsWrap.subviews {
            button.removeFromSuperview()
        }
        
        guard let options = options else {
            return
        }
        
        let count: Int = options.count
        for i in 0..<count {
            let option = options[i]
            let button = UIButton(type: .custom)
            button.tag = i
            button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
            button.setTitleColor(Color_White, for: .normal)
            button.setTitle(option, for: .normal)
            adjustButtonStyle(button, false)
            buttonsWrap.addSubview(button)
        }
        
        setNeedsLayout()
    }
    
    func layoutButtons() {
        let buttonsWrap = self.buttonsWrap
        let buttonCount = buttonsWrap.subviews.count
        if buttonCount==0 {
            return
        }
        
        let width = buttonsWrap.bounds.width
        let buttonWidth: CGFloat = buttonCount > 1 ? (width - 5) / 2 : width
        let buttonHeight = self.buttonHeight
        let buttonSpacing = self.buttonSpacing
        for i in 0..<buttonCount {
            let button = buttonsWrap.subviews[i]
            let column = i % 2
            let row = i / 2
            button.frame = CGRect(x: CGFloat(column) * (buttonWidth + buttonSpacing), y: CGFloat(row) * (buttonHeight + buttonSpacing), width: buttonWidth, height: buttonHeight)
            button.layer.cornerRadius = buttonHeight / 5;
        }
    }
    
    func adjustButtonStyle(_ button: UIButton, _ isSelected: Bool) {
        button.isSelected = isSelected
        
        if self.style == .Radio || self.style == .Checkbox {
            if isSelected {
                button.backgroundColor = Color_White
                button.setTitleColor(Color_Tint, for: .normal)
                button.layer.borderWidth = 1;
                button.layer.borderColor = Color_White.cgColor
            } else {
                button.backgroundColor = nil
                button.setTitleColor(Color_White, for: .normal)
                button.layer.borderWidth = 1;
                button.layer.borderColor = Color_White.cgColor
            }
        } else {
            button.backgroundColor = Color_Orange
            button.setTitleColor(Color_White, for: .normal)
            button.layer.borderWidth = 0
            button.layer.borderColor = nil
        }
        
    }
    
}
