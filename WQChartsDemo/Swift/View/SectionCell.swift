// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// SectionCell.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class SectionCell: UIView {
    
    // MARK: - Property
    
    open lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 9)
        textLabel.textColor = Color_White
        return textLabel
    }()
    
    open lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Color_White
        button.titleLabel?.font = UIFont.systemFont(ofSize: 9)
        button.setTitleColor(Color_Tint, for: .normal)
        button.setTitle("Reload", for: .normal)
        button.addTarget(self, action: #selector(callButtonClick), for: .touchUpInside)
        return button
    }()
    
    
    open var object: Any?

    open func setObject(_ object: Any?) -> SectionCell {
        self.object = object
        return self
    }
    
    open var title: String? {
        get {
            return textLabel.text
        } set {
            textLabel.text = newValue
            setNeedsLayout()
        }
    }
    
    open func setTitle(_ title: String?) -> SectionCell {
        textLabel.text = title
        return self
    }
    
    open var onReload: ((_ cell: SectionCell) -> Void)?
    
    open func setOnReload(_ onReload: ((_ cell: SectionCell) -> Void)?) -> SectionCell {
       self.onReload = onReload
       return self
    }
    
    // MARK: - Public
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(textLabel)
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let height = bounds.height
        
        let button = self.button
        let buttonSize = CGSize(width: 40, height: 25)
        button.frame = CGRect(x: width - buttonSize.width - 10, y: (height - buttonSize.height) / 2, width: buttonSize.width, height: buttonSize.height)
        
        let textLabel = self.textLabel
        textLabel.sizeToFit()
        let textSize = textLabel.bounds.size
        textLabel.frame = CGRect(x: 10, y: (height - textSize.height) / 2, width: button.frame.minX - 20, height: textSize.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: min(size.height,40))
    }
    
    @objc open func callButtonClick() {
        if let onReload = onReload {
            onReload(self)
        }
    }
    
    
}
