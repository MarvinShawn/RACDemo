//
//  PinkView.h
//  RACDemo
//
//  Created by ww on 16/7/26.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSignal;
@interface PinkView : UIView

@property (nonatomic,strong,readonly) RACSignal *buttonClickSignal;

@end
