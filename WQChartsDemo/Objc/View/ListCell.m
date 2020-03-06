// 代码地址: 
// ListCell.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "ListCell.h"

@interface ListCell()

@property (nonatomic) CGFloat buttonHeight;

@property (nonatomic, strong) ListView* contentView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* appendButton;
@property (nonatomic, strong) UIButton* removeButton;

@end

@implementation ListCell

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.buttonHeight = 25;
        self.backgroundColor = UIColor.clearColor;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat insetTop = 10;
    
    UILabel* textLabel = self.titleLabel;
    [textLabel sizeToFit];
    textLabel.frame = CGRectMake(10, insetTop, width - 20, textLabel.bounds.size.height);
    insetTop = CGRectGetMaxY(textLabel.frame);
    
    CGFloat insetBottom = 10;
    if (self.isMutable) {
        CGFloat buttonWidth = width / 2;
        CGFloat buttonHeight = self.buttonHeight;
        _appendButton.frame = CGRectMake(0, height - insetBottom - buttonHeight, buttonWidth, buttonHeight);
        _removeButton.frame = CGRectMake(buttonWidth, height - insetBottom - buttonHeight, buttonWidth, buttonHeight);
        insetBottom += buttonHeight;
    }
    
    self.contentView.frame = CGRectMake(0, insetTop, width, height - insetTop - insetBottom);
}


- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 10;
    [self.titleLabel sizeToFit];
    height += self.titleLabel.bounds.size.height;
    height += [self.contentView sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)].height;
    if(self.isMutable) {
        height += self.buttonHeight;
    }
    height += 10;
    return CGSizeMake(size.width, MIN(size.height, height));
}


- (ListCell*(^)(NSString*))setTitle {
    return ^ListCell *(NSString *title) {
        self.title = title;
        return self;
    };
}

- (ListCell*(^)(BOOL))setIsMutable {
    return ^ListCell *(BOOL isMutable) {
        self.isMutable = isMutable;
        return self;
    };
}

- (ListCell*(^)(NSArray<UIView*>*))setItems {
    return ^ListCell *(NSArray<UIView*>* subcells) {
        self.contentView.items = subcells;
        return self;
    };
}

- (ListCell*(^)(void(^)(ListCell*)))setOnAppend {
    return ^ListCell*(void(^onAppend)(ListCell*)) {
        self.onAppend = onAppend;
        return self;
    };
}

- (ListCell*(^)(void(^)(ListCell*)))setOnRemove {
    return ^ListCell*(void(^onRemove)(ListCell*)) {
        self.onRemove = onRemove;
        return self;
    };
}

- (ListCell*(^)(UIView*))addItem {
    return ^ListCell *(UIView* subcell) {
        [self.contentView addItem:subcell];
        return self;
    };
}

- (ListCell*(^)(NSInteger))removeItemAtIndex {
    return ^ListCell *(NSInteger index) {
        [self.contentView removeItemAt:index];
        return self;
    };
}

#pragma mark - Getter


- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = Color_White;
    }
    return _titleLabel;
}

- (ListView *)contentView {
    if(!_contentView) {
        _contentView = ListView.new;
    }
    return _contentView;
}


#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setIsMutable:(BOOL)isMutable {
    _isMutable = isMutable;
    
    if (isMutable) {
        if (!_appendButton) {
            UIButton* appendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            appendButton.backgroundColor = Color_Tint;
            appendButton.titleLabel.font = [UIFont systemFontOfSize:9];
            [appendButton setTitle:@"Append" forState:UIControlStateNormal];
            [appendButton addTarget:self action:@selector(onAppendButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:appendButton];
            _appendButton = appendButton;
        }
        
        if (!_removeButton) {
            UIButton* removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            removeButton.backgroundColor = Color_Red;
            removeButton.titleLabel.font = [UIFont systemFontOfSize:9];
            [removeButton setTitle:@"Remove" forState:UIControlStateNormal];
            [removeButton addTarget:self action:@selector(onRemoveButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:removeButton];
            _removeButton = removeButton;
        }
    } else {
        [_appendButton removeFromSuperview];
        _appendButton = nil;
        
        [_removeButton removeFromSuperview];
        _removeButton = nil;
    }
    
    [self setNeedsLayout];
}

#pragma mark - Private

- (void)onAppendButtonClick {
    if(self.onAppend) {
        self.onAppend(self);
    }
}

- (void)onRemoveButtonClick {
    if(self.onRemove) {
        self.onRemove(self);
    }
}

@end
