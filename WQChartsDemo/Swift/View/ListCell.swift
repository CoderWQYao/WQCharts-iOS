// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// ListCell.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class ListCell: UIView {
    
    open lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textColor = Color_White
        return titleLabel
    }()
    
    open lazy var contentView: ListView = {
        let contentView = ListView()
        return contentView
    }()
    
    var _appendButton: UIButton?
    var _removeButton: UIButton?
    var buttonHeight = CGFloat(25)
    
    open var title: String? {
        didSet {
            titleLabel.text = title
            setNeedsLayout()
        }
    }
    
    open func setTitle(_ title: String?) -> ListCell {
        self.title = title
        return self
    }
    
    open var isMutable = false {
        didSet {
            if isMutable {
                if _appendButton == nil {
                    let appendButton = UIButton()
                    appendButton.backgroundColor = Color_Tint
                    appendButton.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                    appendButton.setTitle("Append", for: .normal)
                    appendButton.addTarget(self, action: #selector(onAppendButtonClick), for: .touchUpInside)
                    addSubview(appendButton)
                    _appendButton = appendButton
                }
                
                if _removeButton == nil {
                    let removeButton = UIButton()
                    removeButton.backgroundColor = Color_Red
                    removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                    removeButton.addTarget(self, action: #selector(onRemoveButtonClick), for: .touchUpInside)
                    removeButton.setTitle("Remove", for: .normal)
                    addSubview(removeButton)
                    _removeButton = removeButton
                }
            } else {
                if let addButton = _appendButton {
                    addButton.removeFromSuperview()
                    _appendButton = nil
                }
                if let removeButton = _removeButton {
                    removeButton.removeFromSuperview()
                    _removeButton = nil
                }
            }
            setNeedsLayout()
        }
    }
    
    open func setIsMutable(_ isMutable: Bool) -> ListCell {
        self.isMutable = isMutable
        return self
    }
    
    var onAppend: ((_ sliderListView: ListCell) -> Void)?
    open func setOnAppend(_ onAppend: ((_ sliderListView: ListCell) -> Void)?) -> ListCell {
        self.onAppend = onAppend
        return self
    }
    
    var onRemove: ((_ sliderListView: ListCell) -> Void)?
    open func setOnRemove(_ onRemove: ((_ sliderListView: ListCell) -> Void)?) -> ListCell {
        self.onRemove = onRemove
        return self
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width
        let height = bounds.height

        var insetTop: CGFloat = 10
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: insetTop, width: width - 20, height: titleLabel.bounds.height)
        insetTop = titleLabel.frame.maxY

        var insetBottom: CGFloat = 10
        if isMutable {
           let buttonWidth = width / 2
           let buttonHeight = self.buttonHeight
           _appendButton?.frame = CGRect(x: 0, y: height - insetBottom - buttonHeight, width: buttonWidth, height: buttonHeight)
           _removeButton?.frame = CGRect(x: buttonWidth, y: height - insetBottom - buttonHeight, width: buttonWidth, height: buttonHeight)
           insetBottom += buttonHeight
        }

        contentView.frame = CGRect(x: 0, y: insetTop, width: width, height: height - insetTop - insetBottom)
    }
  
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 10
        titleLabel.sizeToFit()
        height += titleLabel.bounds.height
        height += self.contentView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)).height
        if isMutable {
            height += buttonHeight
        }
        height += 10
        return CGSize(width: size.width, height: min(size.height, height))
    }
    
    
    open func addItem(_ item: UIView) -> ListCell{
        contentView.addItem(item)
        return self
    }
    
    open func removeItem(at index: Int) -> ListCell {
        contentView.removeItem(at: index)
        return self
    }
    
    @objc func onAppendButtonClick() {
        guard let onAppend = onAppend else {
            return
        }
        onAppend(self)
    }
    
    @objc func onRemoveButtonClick() {
        guard let onRemove = onRemove else {
            return
        }
        onRemove(self)
    }
    
}
