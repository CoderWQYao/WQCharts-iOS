// 代码地址: 
// RadioCell.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "RadioCell.h"

@interface RadioCell() {
    UILabel* _titleLabel;
    UIView* _buttonsView;
}

@property (nonatomic) CGFloat buttonHeight;
@property (nonatomic) CGFloat buttonSpacing;

@end

@implementation RadioCell

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.buttonHeight = 25;
        self.buttonSpacing = 5;
        self.backgroundColor = UIColor.clearColor;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.buttonsView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat offsetY = 10;
    
    UILabel* titleLabel = self.titleLabel;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(10, offsetY, width - 20, CGRectGetHeight(titleLabel.bounds));
    offsetY = CGRectGetMaxY(self.titleLabel.frame) + 5;
    
    UIView* buttonsView = self.buttonsView;
    buttonsView.frame = CGRectMake(10, offsetY, width - 20, height - offsetY - 10);
    [self layoutButtonsView];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 10;
    
    UILabel* titleLabel = self.titleLabel;
    [titleLabel sizeToFit];
    height += titleLabel.bounds.size.height;
    
    NSInteger buttonCount = self.buttonsView.subviews.count;
    if (buttonCount > 0) {
        NSInteger buttonRowCount = buttonCount / 2 + (buttonCount % 2 > 0 ? 1 : 0);
        height += buttonRowCount * (self.buttonHeight + self.buttonSpacing);
    }
    
    height += 10;
    return CGSizeMake(size.width, MIN(height, size.height));
}

- (void)callSectionChange {
    if(_onSelectionChange!=nil) {
        _onSelectionChange(self, self.selection);
    }
}

#pragma mark - Getter

- (NSString *)title {
    return self.titleLabel.text;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = Color_White;
    }
    return _titleLabel;
}

- (UIView *)buttonsView {
    if(!_buttonsView) {
        _buttonsView = UIView.new;
    }
    return _buttonsView;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setOptions:(NSArray<NSString*>*)options {
    _options = options;
    
    UIView* buttonsView = self.buttonsView;
    for (UIView* button in buttonsView.subviews) {
        [button removeFromSuperview];
    }
    
    if(options==nil) {
        return;
    }
    
    NSInteger count = options.count;
    NSInteger selection = self.selection;
    if(selection < 0 || selection > count - 1) {
        selection = 0;
    }
    
    for (NSInteger i=0; i<count; i++) {
        NSString* option = options[i];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        [button setTitle:option forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = Color_White.CGColor;
        [self adjustButton:button isSelected:i==selection];
        [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:button];
    }
    
    if(self.selection!=selection) {
        self.selection = selection;
        [self callSectionChange];
    }
    
    [self setNeedsLayout];
}

- (void)setSelection:(NSInteger)selection {
    _selection = selection;
    [self selectButton:self.buttonsView.subviews[selection]];
}

- (RadioCell*(^)(NSString*))setTitle {
    return ^RadioCell *(NSString *title) {
        self.title = title;
        return self;
    };
}

- (RadioCell*(^)(NSArray<NSString*>*))setOptions {
    return ^RadioCell *(NSArray<NSString *>* options) {
        self.options = options;
        return self;
    };
}

- (RadioCell*(^)(NSInteger))setSelection {
    return ^RadioCell *(NSInteger selection) {
        self.selection = selection;
        return self;
    };
}

- (RadioCell*(^)(void (^)(RadioCell*, NSInteger)))setOnSelectionChange {
    return ^RadioCell *(void (^onSelectionChange)(RadioCell*, NSInteger)) {
        self.onSelectionChange = onSelectionChange;
        return self;
    };
}

#pragma mark - Private

- (void)layoutButtonsView {
    UIView* buttonsView = self.buttonsView;
    NSInteger buttonCount = buttonsView.subviews.count;
    if(buttonCount==0) {
        return;
    }
    
    CGFloat width = buttonsView.bounds.size.width;
    CGFloat buttonWidth = buttonCount > 1 ? (width - 5) / 2 : width;
    CGFloat buttonHeight = self.buttonHeight;
    CGFloat buttonSpacing = self.buttonSpacing;
    for (NSInteger i=0; i<buttonCount; i++) {
        UIView* button = buttonsView.subviews[i];
        NSInteger column = i % 2;
        NSInteger row = i / 2;
        button.frame = CGRectMake(column * (buttonWidth + buttonSpacing),row * (buttonHeight + buttonSpacing), buttonWidth, buttonHeight);
        button.layer.cornerRadius = buttonHeight / 5;
    }
}

- (void)handleButtonClick:(UIButton*)sender {
    [self selectButton:sender];
}

- (void)selectButton:(UIButton*)button {
    for (UIView* subview in self.buttonsView.subviews) {
        [self adjustButton:(UIButton*)subview isSelected:button==subview];
    }
    
    NSInteger oldSelection = self.selection;
    if(oldSelection!=button.tag) {
        self.selection = button.tag;
        [self callSectionChange];
    }
}

- (void)adjustButton:(UIButton*)button isSelected:(BOOL)isSelected {
    button.selected = isSelected;
    if(isSelected) {
        button.backgroundColor = Color_White;
        [button setTitleColor:Color_Tint forState:UIControlStateNormal];
    } else {
        button.backgroundColor = nil;
        [button setTitleColor:Color_White forState:UIControlStateNormal];
    }
}


@end
