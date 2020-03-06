// 代码地址: 
// ListView.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit



class ListView: UIScrollView {
    
    enum ScrollPosition {
        case Top,Middle,Bottom
    }
    
    private var _items = NSMutableArray()
    open var items: [UIView] {
        get {
            return _items as! [UIView]
        }
    }
    
    private var _needsReload = false
    private var _lastLayoutSize = CGSize.zero
    private var _scrollItemIndex = Int(0)
    private var _scrollItemPosition = ScrollPosition.Top
    private var _scrollItemAnimated = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        _needsReload = false
        _scrollItemIndex = NSNotFound
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        if _needsReload || !_lastLayoutSize.equalTo(size) {
            _needsReload = false
            
            let width = size.width
            var offsetY = CGFloat(0)
            for item in items {
                let cellHeight = item.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
                item.frame = CGRect(x: 0, y: offsetY, width: width, height: cellHeight)
                offsetY = item.frame.maxY
            }
            contentSize = CGSize(width: width, height: offsetY)
            
            if _scrollItemIndex != NSNotFound {
                scrollToItem(_scrollItemIndex, _scrollItemPosition, _scrollItemAnimated)
                _scrollItemIndex = NSNotFound
                _scrollItemPosition = .Top
                _scrollItemAnimated = false
            }
        }
        _lastLayoutSize = size
        
    }
    
    open func addItem(_ item: UIView) {
        addSubview(item)
        _items.add(item)
        setNeedsLayoutItems()
    }
    
    open func removeItem(_ item: UIView) {
        _items.remove(item)
        let index = subviews.firstIndex(of: item)
        if index == NSNotFound {
            return
        }
        item.removeFromSuperview()
        setNeedsLayoutItems()
    }
    
    open func removeItem(at index: Int) {
        let item = _items[index] as! UIView
        removeItem(item)
    }
    
    open func setNeedsLayoutItems() {
        _needsReload = true
        setNeedsLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var contentHeight = CGFloat(0)
        for item in self.items {
            contentHeight += item.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)).height
        }
        return CGSize(width: size.width, height: min(size.height, contentHeight))
    }
    
    
    open func scrollToItem(_ index: Int, _ scrollPosition: ScrollPosition, _ animated: Bool) {
        if _needsReload {
            _scrollItemIndex = index
            _scrollItemPosition = scrollPosition
            _scrollItemAnimated = animated
            return
        }
        
        var contentOffset = self.contentOffset
        let item = items[index]
        switch (scrollPosition) {
        case .Middle:
            contentOffset.y = item.frame.midY - bounds.size.height / 2
            break
        case .Bottom:
            contentOffset.y = max(0,item.frame.maxY - bounds.size.height)
            break
        default:
            contentOffset.y = min(contentSize.height - bounds.size.height, item.frame.minY)
            break
        }
        setContentOffset(contentOffset, animated: animated)
    }
}
