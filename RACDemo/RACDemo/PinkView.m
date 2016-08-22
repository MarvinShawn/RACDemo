//
//  PinkView.m
//  RACDemo
//
//  Created by ww on 16/7/26.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "PinkView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PinkView ()

@property (nonatomic,strong) RACSignal *buttonClickSignal;

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentCtl;


@end
@implementation PinkView

- (IBAction)buttonActionTest:(UIButton *)sender {

    
    [UIView animateWithDuration:0.3 animations:^{
        
        sender.transform = CGAffineTransformMakeScale(1.3, 1.3);
        
    } completion:^(BOOL finished) {
        
        sender.transform = CGAffineTransformIdentity;
        
    }];

}


- (RACSignal *)buttonClickSignal {

    if (_buttonClickSignal == nil) {
        _buttonClickSignal = [[[self rac_signalForSelector:@selector(buttonActionTest:)] map:^id(RACTuple *value) {
            
            UIButton *button = value.first;
            
            return button.currentTitle;
            
        }] merge:[[self.segmentCtl rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISegmentedControl *value) {
            
            return [value titleForSegmentAtIndex:value.selectedSegmentIndex];
            
        }]];
    }
    return _buttonClickSignal;
    

}
@end
