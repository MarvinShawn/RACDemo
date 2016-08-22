//
//  RegistViewModel.h
//  RACDemo
//
//  Created by ww on 16/7/21.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/EXTScope.h>
@interface RegistViewModel : NSObject

@property (nonatomic,strong) RACCommand *registCommand;

///  账号
@property(nonatomic,copy) NSString *account;

///  密码
@property(nonatomic,copy) NSString *password;

///  邮箱
@property(nonatomic,copy) NSString *email;

///  确认邮箱
@property(nonatomic,copy) NSString *confirmEmail;


@end
