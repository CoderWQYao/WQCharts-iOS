// 代码地址: 
// SectionCell.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "SectionCell.h"

@interface SectionCell()

@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic, strong) UIButton* button;

@end

@implementation SectionCell

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.textLabel];
        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    UIButton* button = self.button;
    CGSize buttonSize = CGSizeMake(40, 25);
    button.frame = CGRectMake(width - buttonSize.width - 10, (height - buttonSize.height) / 2, buttonSize.width, buttonSize.height);
    
    UILabel* textLabel = self.textLabel;
    [textLabel sizeToFit];
    CGSize textSize = textLabel.bounds.size;
    textLabel.frame = CGRectMake(10, (height - textSize.height) / 2, CGRectGetMinX(button.frame) - 20, textSize.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, MIN(size.height, 40));
}

#pragma mark - Getter

- (UILabel *)textLabel {
    if(!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:9];
        _textLabel.textColor = Color_White;
    }
    return _textLabel;
}

- (UIButton *)button {
    if(!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = Color_White;
        _button.titleLabel.font = [UIFont systemFontOfSize:9];
        [_button setTitleColor:Color_Tint forState:UIControlStateNormal];
        [_button setTitle:@"Reload" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onReloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (NSString *)title {
    return _textLabel.text;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    self.textLabel.text = title;
    [self setNeedsLayout];
}

- (SectionCell*(^)(id))setObject {
    return ^SectionCell*(id object) {
        self.objcect = object;
        return self;
    };
}

- (SectionCell*(^)(NSString*))setTitle {
    return ^SectionCell*(NSString* title) {
        self.title = title;
        return self;
    };
}

- (SectionCell*(^)(SectionCellReloadHandler))setOnReload {
    return ^SectionCell*(SectionCellReloadHandler onReload) {
        self.onReload = onReload;
        return self;
    };
}

- (void)onReloadButtonClick {
    if(self.onReload) {
        self.onReload(self);
    }
}

@end
