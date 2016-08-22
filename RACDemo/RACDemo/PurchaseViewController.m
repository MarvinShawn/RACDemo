//
//  PurchaseViewController.m
//  RACDemo
//
//  Created by ww on 16/7/24.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "PurchaseViewController.h"
#import "BTangSingleModel.h"
#import "UIImageView+WebCache.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface PurchaseViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *paymentButton;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initBind];
    
}

- (void)initBind {

    @weakify(self)
    [RACObserve(self, singleModel) subscribeNext:^(BTangSingleModel  *singleModel) {
        @strongify(self)
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:singleModel.pic]];
        self.goodsNameLabel.text = singleModel.title;
        self.descLabel.text = singleModel.desc;
        NSString *priceStr = [NSString stringWithFormat:@"¥%@",singleModel.price];
        self.priceLabel.text = priceStr;
    }];

    /*================ 点击购买按钮 ==================*/
    [[self.paymentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        //弹出一个提示框
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"您确定支付吗?" delegate:self cancelButtonTitle:@"我再看看" otherButtonTitles:@"支付", nil];
        [alertView show];
        
        [[alertView rac_buttonClickedSignal] subscribeNext:^(RACTuple *tuple) {
            
            if ([tuple  isEqual: @(1)]) {
                
                self.isPurchased = YES;
                
            }
            
        }];
        
    }];

}

@end
