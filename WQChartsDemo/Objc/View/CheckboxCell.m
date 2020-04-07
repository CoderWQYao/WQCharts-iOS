// https://github.com/CoderWQYao/WQCharts-iOS
//
// CheckboxCell.m
// WQCharts
//
// Created by WQ.Yao on 2020/01/02.
// Copyright (c) 2020年 WQ.Yao All rights reserved.
//

#import "CheckboxCell.h"

@implementation CheckboxCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.style = ButtonsCellStyleCheckBox;
    }
    return self;
}

- (NSArray<NSNumber *> *)selections {
    NSMutableArray<NSNumber *>* selections = [NSMutableArray array];
    for (NSInteger i=0; i<self.buttonsWrap.subviews.count; i++) {
        UIButton* button = self.buttonsWrap.subviews[i];
        if(button.isSelected) {
            [selections addObject:@(i)];
        }
    }
    return selections;
}

- (void)setSelections:(NSArray<NSNumber *> *)selections {
    for (NSInteger i=0; i<self.buttonsWrap.subviews.count; i++) {
        UIButton* button = self.buttonsWrap.subviews[i];
        [self adjustButtonStyle:button isSelected:NO];
    }
    
    for (NSInteger i=0; i<selections.count; i++) {
        NSInteger selection = [selections[i] integerValue];
        [self adjustButtonStyle:self.buttonsWrap.subviews[selection] isSelected:YES];
    }
}

- (CheckboxCell*(^)(NSString*))setTitle {
    return ^CheckboxCell *(NSString *title) {
        self.title = title;
        return self;
    };
}

- (CheckboxCell*(^)(NSArray<NSString*>*))setOptions {
    return ^CheckboxCell *(NSArray<NSString *>* options) {
        self.options = options;
        return self;
    };
}

- (CheckboxCell * _Nonnull (^)(NSArray<NSNumber *> * _Nonnull))setSelections {
    return ^CheckboxCell *(NSArray<NSNumber *> * selections) {
        self.selections = selections;
        return self;
    };
}

- (CheckboxCell*(^)(void (^)(CheckboxCell*, NSArray<NSNumber*>*)))setOnSelectionsChange {
    return ^CheckboxCell *(void (^onSelectionsChange)(CheckboxCell*, NSArray<NSNumber*>*)) {
        self.onSelectionsChange = onSelectionsChange;
        return self;
    };
}


- (void)callSectionsChange {
    if (self.onSelectionsChange) {
        self.onSelectionsChange(self, self.selections);
    }
}

- (void)rebuildButtons {
    NSArray<NSNumber*>* selections = self.selections;
    
    [super rebuildButtons];
    
    UIView* buttonsWrap = self.buttonsWrap;
    for (UIButton* button in buttonsWrap.subviews) {
        [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    BOOL selectionsChanged = NO;
    NSInteger buttonCount = buttonsWrap.subviews.count;
    for (NSInteger i = 0; i<selections.count; i++) {
        NSInteger selection = [selections[i] integerValue];
        if (selection < 0 || selection > buttonCount - 1) {
            selectionsChanged = YES;
        } else {
            [self adjustButtonStyle:buttonsWrap.subviews[selection] isSelected:YES];
        }
    }
    
    if (selectionsChanged) {
        [self callSectionsChange];
    }
}


- (void)handleButtonClick:(UIButton *)sender {
    [self adjustButtonStyle:sender isSelected:!sender.selected];
    [self callSectionsChange];
}

@end
