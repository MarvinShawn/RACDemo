//
//  ToolButton.h
//  RACDemo
//
//  Created by ww on 16/7/23.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolButton : UIButton
///  快速创建一个toolButton
+ (instancetype)buttonWithNormalTitle:(NSString *)normalTitle normalImageName:(NSString *)normalImageName tag:(NSInteger)tag target:( id)target action:( SEL) action forControlEvents:(UIControlEvents) event;
@end
