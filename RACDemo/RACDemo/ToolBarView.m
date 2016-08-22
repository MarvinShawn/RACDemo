//
//  toolBarView.m
//  RACDemo
//
//  Created by ww on 16/7/22.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "ToolBarView.h"
#import "ToolButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ToolBarView ()

@property (nonatomic,strong) ToolButton *selectedToolButton;
@property (nonatomic,weak) ToolButton *defaultBtn;
@property (nonatomic,strong) RACSignal *rac_clickButton;
@end
@implementation ToolBarView

- (instancetype)init {

    if (self = [super init]) {
        
        [self addChildView];
        self.backgroundColor = [UIColor blackColor];
        self.distribution = UIStackViewDistributionFillEqually;
        self.selectedToolButton.selected = YES;
    
    }
    
    return self;

}

- (void)addChildView {


    ToolButton *defaultBtn = [ToolButton buttonWithNormalTitle:@"默认" normalImageName:nil tag:0 target:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchDown];
    self.selectedToolButton = defaultBtn;
    
    ToolButton *hotBtn = [ToolButton buttonWithNormalTitle:@"热度" normalImageName:nil tag:1 target:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchDown];

    ToolButton *newestBtn = [ToolButton buttonWithNormalTitle:@"最新" normalImageName:nil tag:2 target:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchDown];

    ToolButton *priceBtn = [ToolButton buttonWithNormalTitle:@"价格" normalImageName:@"YellowDownArrow" tag:3 target:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchDown];
    
    priceBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [priceBtn addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tap) {
        
        UIButton *button = (UIButton *)tap.view;
        //这里给价格按钮加手势的原因是,价格按钮有升序和降序两种情况,
        if (button.tag == 3) {
            button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }else {
            button.imageView.transform = CGAffineTransformIdentity;
        }
            button.tag = button.tag == 3 ? 4:3;
    }];
    
    
    [self addArrangedSubview:defaultBtn];
    [self addArrangedSubview:hotBtn];
    [self addArrangedSubview:newestBtn];
    [self addArrangedSubview:priceBtn];
} 


- (void)buttonClickAction:(ToolButton *)sender {

    if (sender == self.selectedToolButton) {
        return;
    }
    
    self.selectedToolButton.selected = NO;
    sender.selected = YES;
    self.selectedToolButton = sender;
    
}

- (RACSignal *)rac_clickButton {

    if (_rac_clickButton == nil) {
        
        RACSignal *clickActionSignal = [[self rac_signalForSelector:@selector(buttonClickAction:)] map:^id(RACTuple *tuple) {
            ToolButton *btn = tuple.first;
            return @(btn.tag);
            
        }];
        
        RACSignal *defaultSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@(0)];
            [subscriber sendCompleted];
            return nil;
        }];
        
// merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
        _rac_clickButton = [clickActionSignal merge:defaultSignal];

    }
    return _rac_clickButton;
    
}

@end
