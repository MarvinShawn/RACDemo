//
//  RegistViewModel.m
//  RACDemo
//
//  Created by ww on 16/7/21.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "RegistViewModel.h"
#import "NSString+RegularExpression.h"
@implementation RegistViewModel


- (instancetype)init {

    if (self = [super init]) {
        
        [self initBind];
    }
    
    return self;

}

- (void)initBind {

    //账户名不为空,

    RACSignal *accountSignal = [RACObserve(self, account) map:^id(NSString *value) {

        NSString *pattern = @"^[A-Za-z0-9]+$";   // 字母数字
        
        //返回一个BOOL值
        return  @([value matchWithPattern:pattern]);
        
    }];
    
    //密码长度要大于等于6
    RACSignal *passwordSignal  = [RACObserve(self, password) map:^id(NSString *value) {
        
        return  @(value.length >= 6);
        
    }];
    
    
    //  邮箱格式检测
    RACSignal *emailTogetherSignal = [RACSignal combineLatest:@[RACObserve(self, email),RACObserve(self, confirmEmail)] reduce:^id(NSString *emailStr, NSString *confirmEmailStr){
        
        NSString *pattern = @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
        
        return @([emailStr matchWithPattern:pattern] && [emailStr isEqualToString:confirmEmailStr]) ;
    }];
    
    //先 组合信号  再  聚合信号
   RACSignal *registSignal =   [RACSignal combineLatest:@[accountSignal,passwordSignal,emailTogetherSignal] reduce:^id(NSNumber *accountValue,NSNumber *passwordValue,NSNumber *emailValue){
        
        return @(accountValue.boolValue && passwordValue.boolValue && emailValue.boolValue);
    }];
    
    
    self.registCommand = [[RACCommand alloc] initWithEnabled:registSignal signalBlock:^RACSignal *(id input) {
    
        return [[RACSignal empty] delay:3];
        
    }];
    


}
@end
