//
//  ViewControllerTwo.m
//  RACDemo
//
//  Created by ww on 16/7/26.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "ViewControllerTwo.h"

@interface ViewControllerTwo ()
@property (weak, nonatomic) IBOutlet UILabel *labelOne;

@end

@implementation ViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {


    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
