//
//  SingleDetailViewModel.h
//  RACDemo
//
//  Created by ww on 16/7/23.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BTangSingleModel.h"
@interface SingleDetailViewModel : NSObject

///  请求网络数据命令
@property (nonatomic,strong) RACCommand *requestCommand;

///  模型数组
@property (nonatomic, strong) NSArray *goodsStatus;

@property (nonatomic,strong) BTangSingleModel *singleModel;
@end
