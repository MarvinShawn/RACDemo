//
//  ToolButton.m
//  RACDemo
//
//  Created by ww on 16/7/23.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "ToolButton.h"

@implementation ToolButton

- (instancetype)init {
    
    if (self = [super init]) {
        
        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return self;

}

+ (instancetype)buttonWithNormalTitle:(NSString *)normalTitle normalImageName:(NSString *)normalImageName tag:(NSInteger)tag target:( id)target action:( SEL) action forControlEvents:(UIControlEvents) event {

    ToolButton *toolButton = [[ToolButton alloc] init];
    
    [toolButton setTitle:normalTitle forState:UIControlStateNormal];
    
    toolButton.tag = tag;
    
    if (normalImageName) {
        [toolButton setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    }

    if (action) {
        NSAssert(target != nil, @"target不能为空");
        
        [toolButton addTarget:target action:action forControlEvents:event];
        
    }

    return toolButton;
}

- (void)setHighlighted:(BOOL)highlighted{}

@end
