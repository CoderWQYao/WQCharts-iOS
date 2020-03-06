// 代码地址: 
// SliderCell.swift
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

import UIKit

class SliderCell: UIView {
    
    // MARK: - Property
    
    typealias OnValueChange = (_ sliderCell: SliderCell, _ value: CGFloat) -> Void
    
    open lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 9)
        textLabel.textAlignment = .right
        textLabel.textColor = Color_White
        return textLabel
    }()
    
    open lazy var slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(onSliderValueChange), for: .valueChanged)
        return slider
    }()
    
    open lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.font = textLabel.font
        placeholderLabel.textAlignment = .right
        return placeholderLabel
    }()
    
    open var value: CGFloat {
        get {
            return CGFloat(Float(textLabel.text ?? "") ?? 0)
        }
        set {
            slider.value = Float(newValue)
            updateTextLabel()
        }
    }
    
    open var minimumValue: CGFloat {
        get {
            return CGFloat(slider.minimumValue)
        } set {
            slider.minimumValue = Float(newValue)
            updateTextLabel()
        }
    }
    
    open var maximumValue: CGFloat {
        get {
            return CGFloat(slider.maximumValue)
        } set {
            slider.maximumValue = Float(newValue)
            updateTextLabel()
        }
    }
    
    open func setSliderValue(_ minimumValue: CGFloat, _ maximumValue: CGFloat, _ value: CGFloat) -> SliderCell {
        let slider = self.slider
        slider.minimumValue = Float(minimumValue)
        slider.maximumValue = Float(maximumValue)
        slider.value = Float(value)
        updateTextLabel()
        return self
    }
    
    open var decimalCount = Int(0) {
        didSet {
            updateTextLabel()
        }
    }
    
    open func setDecimalCount(_ decimalCount: Int) -> SliderCell {
        self.decimalCount = decimalCount
        return self
    }
    
    open var onValueChange: OnValueChange?
    
    open func setOnValueChange(_ onValueChange: OnValueChange?) -> SliderCell {
        self.onValueChange = onValueChange
        return self
    }
    
    public var object: Any?
    
    public func setObject(_ object: Any?) -> SliderCell {
        self.object = object
        return self
    }

    // MARK: - Public
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(slider)
        addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width
        let height = bounds.height
        
        let textLabel = self.textLabel
        let placeholderLabel = self.placeholderLabel
        placeholderLabel.sizeToFit()
        var textSize = placeholderLabel.bounds.size
        textSize.width += 6
        textLabel.frame = CGRect(x: width - textSize.width - 5, y: (height - textSize.height) / 2, width: textSize.width, height: textSize.height)
        
        let slider = self.slider
        slider.sizeToFit()
        slider.frame = CGRect(x: 5, y: (height - slider.bounds.height) / 2, width: textLabel.frame.minX - 5, height: slider.bounds.height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: min(size.height,40))
    }
    
    open func callSliderValueChange() {
        if let onValueChange = onValueChange {
            onValueChange(self,value)
        }
    }
    
    // MARK: - Private
    
    func createValueString(_ value: Float) -> String {
        let format = String(format: "%%.%ldf", decimalCount)
        return String(format: format, decimalCount == 0 ? round(value) : value)
    }
    
    func updateTextLabel() {
        let slider = self.slider
        textLabel.text = createValueString(slider.value)
        placeholderLabel.text = String(format: "-%@", createValueString(max(abs(slider.minimumValue),abs(slider.maximumValue))))
        setNeedsLayout()
    }
    
    @objc func onSliderValueChange()  {
        let textLabel = self.textLabel
        let oldString = textLabel.text
        updateTextLabel()
        let newString = textLabel.text
        if oldString != newString {
            callSliderValueChange()
        }
    }
    
    
}
