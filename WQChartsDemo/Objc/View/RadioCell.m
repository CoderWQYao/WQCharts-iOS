// https://github.com/CoderWQYao/WQCharts-iOS
//
// RadioCell.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "RadioCell.h"

@interface RadioCell()


@end

@implementation RadioCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.style = ButtonsCellStyleRadio;
    }
    return self;
}

#pragma mark - Getter

- (NSInteger)selection {
    for (NSInteger i=0; i<self.buttonsWrap.subviews.count; i++) {
        UIButton* button = self.buttonsWrap.subviews[i];
        if(button.isSelected) {
            return i;
        }
    }
    return 0;
}

#pragma mark - Setter

- (void)setSelection:(NSInteger)selection {
    for (NSInteger i=0; i<self.buttonsWrap.subviews.count; i++) {
        UIButton* button = self.buttonsWrap.subviews[i];
        [self adjustButtonStyle:button isSelected:i == selection];
    }
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

#pragma mark - Public

- (void)callSectionChange {
    if(_onSelectionChange!=nil) {
        _onSelectionChange(self, self.selection);
    }
}

#pragma mark - Internal

- (void)rebuildButtons {
    NSInteger selection = self.selection;
    
    [super rebuildButtons];
    
    UIView* buttonsWrap = self.buttonsWrap;
    for (UIButton* button in buttonsWrap.subviews) {
        [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    BOOL selectionChanged = NO;
    NSInteger buttonCount = buttonsWrap.subviews.count;
    if (selection < 0 || selection > buttonCount - 1) {
        selectionChanged = YES;
    }
    
    if (buttonCount > 0) {
        UIButton* button = buttonsWrap.subviews[selection];
        [self adjustButtonStyle:button isSelected:true];
    }
    
    if (selectionChanged) {
        [self callSectionChange];
    }
    
}

- (void)handleButtonClick:(UIButton *)sender {
    if (self.selection == [self.buttonsWrap.subviews indexOfObject:sender]) {
        return;
    }
    
    for (UIButton* button in self.buttonsWrap.subviews) {
        [self adjustButtonStyle:button isSelected:button == sender];
    }
    
    [self callSectionChange];
}

@end
