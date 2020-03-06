// 代码地址: https://github.com/CoderWQYao/WQCharts-iOS
//
// SliderCell.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "SliderCell.h"

@interface SliderCell()

@property (nonatomic, strong) UISlider* slider;
@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic, strong) UILabel* placeholderLabel;

@end

@implementation SliderCell

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.slider];
        [self addSubview:self.textLabel];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    UILabel* textLabel = self.textLabel;
    UILabel* placeholderLabel = self.placeholderLabel;
    [placeholderLabel sizeToFit];
    CGSize textSize = placeholderLabel.bounds.size;
    textSize.width += 6;
    textLabel.frame = CGRectMake(width - textSize.width - 5, (height - textSize.height) / 2, textSize.width, textSize.height);
    
    UISlider* slider = self.slider;
    [slider sizeToFit];
    slider.frame = CGRectMake(5, (height - slider.bounds.size.height) / 2, CGRectGetMinX(textLabel.frame) - 5, slider.bounds.size.height);
}


- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, MIN(size.height, 40));
}

- (void)callSliderValueChange {
    if(self.onValueChange) {
        self.onValueChange(self, self.value);
      }
}

#pragma mark - Getter

- (UISlider *)slider {
    if(!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.tintColor = Color_Tint;
        [_slider addTarget:self action:@selector(onSliderValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)textLabel {
    if(!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:9];
        _textLabel.textAlignment = NSTextAlignmentRight;
        _textLabel.textColor = Color_White;
    }
    return _textLabel;
}

- (UILabel *)placeholderLabel {
    if(!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = self.textLabel.font;
        _placeholderLabel.textAlignment = NSTextAlignmentRight;
    }
    return _placeholderLabel;
}

- (float)value {
    return _slider.value;
}

- (float)minimumValue {
    return _slider.minimumValue;
}

- (float)maximumValue {
    return _slider.maximumValue;
}

#pragma mark Setter

- (void)setValue:(float)value {
    _slider.value = value;
    [self updateTextLabel];
}

- (void)setMinimumValue:(float)minimumValue {
    _slider.minimumValue = minimumValue;
    [self updateTextLabel];
}

-(void)setMaximumValue:(float)maximumValue {
    _slider.maximumValue = maximumValue;
    [self updateTextLabel];
}


- (SliderCell*(^)(float,float,float))setSliderValue {
    return ^SliderCell *(float minimumValue,float maximumValue,float value) {
        UISlider* slider = self.slider;
        slider.minimumValue = minimumValue;
        slider.maximumValue = maximumValue;
        slider.value = value;
        [self updateTextLabel];
        return self;
    };
}

- (void)setDecimalCount:(NSInteger)decimalCount {
    _decimalCount = decimalCount;
    [self updateTextLabel];
}

- (SliderCell*(^)(NSInteger))setDecimalCount {
    return ^SliderCell *(NSInteger decimalCount) {
        self.decimalCount = decimalCount;
        return self;
    };
}

- (SliderCell*(^)(SliderCellOnValueChange))setOnValueChange {
    return ^SliderCell *(SliderCellOnValueChange onValueChange) {
        self.onValueChange = onValueChange;
        return self;
    };
}

- (SliderCell*(^)(id))setObject {
    return ^SliderCell *(id objcect) {
        self.object = objcect;
        return self;
    };
}

#pragma mark Private

- (NSString*)createValueStringWithValue:(float)value {
    NSString* format = [NSString stringWithFormat:@"%%.%ldf",self.decimalCount];
    return [NSString stringWithFormat:format,self.decimalCount == 0 ? round(value) : value];
 }

- (void)updateTextLabel {
    UISlider* slider = self.slider;
    self.textLabel.text = [self createValueStringWithValue:slider.value];
    self.placeholderLabel.text = [NSString stringWithFormat:@"-%@",[self createValueStringWithValue:MAX(ABS(slider.minimumValue),ABS(slider.maximumValue))]];
    [self setNeedsLayout];
}

- (void)onSliderValueChange {
    UILabel* textLabel = self.textLabel;
    NSString* oldString = textLabel.text;
    [self updateTextLabel];
    NSString* newString = textLabel.text;
    if(![oldString isEqualToString:newString]) {
        [self callSliderValueChange];
    }
}

@end
