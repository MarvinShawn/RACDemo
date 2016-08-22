//
//  toolBarView.h
//  RACDemo
//
//  Created by ww on 16/7/22.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class ToolButton;
@interface ToolBarView : UIStackView

@property (nonatomic,strong,readonly) RACSignal *rac_clickButton;
//- (void)buttonClickAction:(ToolButton *)sender;
@end
