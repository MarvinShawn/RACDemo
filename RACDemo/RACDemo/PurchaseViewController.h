//
//  PurchaseViewController.h
//  RACDemo
//
//  Created by ww on 16/7/24.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTangSingleModel;
@interface PurchaseViewController : UIViewController

@property (nonatomic,strong) BTangSingleModel *singleModel;
@property (nonatomic,assign) BOOL isPurchased;

@end
