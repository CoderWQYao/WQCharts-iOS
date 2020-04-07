// https://github.com/CoderWQYao/WQCharts-iOS
//
// ButtonsCell.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "ButtonsCell.h"

@interface ButtonsCell()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* buttonsWrap;
@property (nonatomic) CGFloat buttonHeight;
@property (nonatomic) CGFloat buttonSpacing;

@end


@implementation ButtonsCell


#pragma mark - Getter

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = Color_White;
    }
    return _titleLabel;
}

- (UIView *)buttonsWrap {
    if(!_buttonsWrap) {
        _buttonsWrap = UIView.new;
    }
    return _buttonsWrap;
}

- (NSString *)title {
    return self.titleLabel.text;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setOptions:(NSArray<NSString*>*)options {
    _options = options;
    [self rebuildButtons];
}

- (void)setStyle:(ButtonsCellStyle)style {
    _style = style;
    [self rebuildButtons];
}

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.buttonHeight = 25;
        self.buttonSpacing = 5;
        self.backgroundColor = UIColor.clearColor;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.buttonsWrap];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat offsetY = 10;
    
    if (self.title.length > 0) {
        UILabel* titleLabel = self.titleLabel;
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(10, offsetY, width - 20, CGRectGetHeight(titleLabel.bounds));
        offsetY = CGRectGetMaxY(self.titleLabel.frame) + 5;
    }
    
    UIView* buttonsWrap = self.buttonsWrap;
    buttonsWrap.frame = CGRectMake(10, offsetY, width - 20, height - offsetY - 10);
    [self layoutButtons];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 10;
    
    if (self.title.length > 0) {
        UILabel* titleLabel = self.titleLabel;
        [titleLabel sizeToFit];
        height += titleLabel.bounds.size.height;
    }
    
    NSInteger buttonCount = self.buttonsWrap.subviews.count;
    if (buttonCount > 0) {
        NSInteger buttonRowCount = buttonCount / 2 + (buttonCount % 2 > 0 ? 1 : 0);
        height += buttonRowCount * (self.buttonHeight + self.buttonSpacing);
    }
    
    height += 10;
    return CGSizeMake(size.width, MIN(height, size.height));
}

#pragma mark - Internal

- (void)rebuildButtons {
    
    UIView* buttonsWrap = self.buttonsWrap;
    for (UIView* button in buttonsWrap.subviews) {
        [button removeFromSuperview];
    }
    
    NSArray<NSString*>* options = self.options;
    
    if(options==nil) {
        return;
    }
    
    NSInteger count = options.count;
    for (NSInteger i=0; i<count; i++) {
        NSString* option = options[i];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        [button setTitle:option forState:UIControlStateNormal];
        [self adjustButtonStyle:button isSelected:NO];
        [buttonsWrap addSubview:button];
    }
    [self setNeedsLayout];
}

- (void)layoutButtons {
    UIView* buttonsWrap = self.buttonsWrap;
    NSInteger buttonCount = buttonsWrap.subviews.count;
    if(buttonCount==0) {
        return;
    }
    
    CGFloat width = buttonsWrap.bounds.size.width;
    CGFloat buttonWidth = buttonCount > 1 ? (width - 5) / 2 : width;
    CGFloat buttonHeight = self.buttonHeight;
    CGFloat buttonSpacing = self.buttonSpacing;
    for (NSInteger i=0; i<buttonCount; i++) {
        UIView* button = buttonsWrap.subviews[i];
        NSInteger column = i % 2;
        NSInteger row = i / 2;
        button.frame = CGRectMake(column * (buttonWidth + buttonSpacing),row * (buttonHeight + buttonSpacing), buttonWidth, buttonHeight);
        button.layer.cornerRadius = buttonHeight / 5;
    }
}

- (void)adjustButtonStyle:(UIButton*)button isSelected:(BOOL)isSelected {
    button.selected = isSelected;
    
    if (self.style == ButtonsCellStyleRadio || self.style == ButtonsCellStyleCheckBox) {
        if (isSelected) {
            button.backgroundColor = Color_White;
            [button setTitleColor:Color_Tint forState:UIControlStateNormal];
            button.layer.borderWidth = 1;
            button.layer.borderColor = Color_White.CGColor;
        } else {
            button.backgroundColor = nil;
            [button setTitleColor:Color_White forState:UIControlStateNormal];
            button.layer.borderWidth = 1;
            button.layer.borderColor = Color_White.CGColor;
        }
    } else {
        button.backgroundColor = Color_Orange;
        [button setTitleColor:Color_White forState:UIControlStateNormal];
        button.layer.borderWidth = 0;
        button.layer.borderColor = nil;
    }
    
}

@end
