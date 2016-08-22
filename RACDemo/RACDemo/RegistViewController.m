//
//  RegistViewController.m
//  RACDemo
//
//  Created by ww on 16/7/21.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistViewModel.h"
#import "LoginViewController.h"
#import "NSString+RegularExpression.h"

@interface RegistViewController ()

@property (nonatomic,strong) RegistViewModel *registViewModel;
///  账户名
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
///  密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
///  邮箱
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
///  确认邮箱
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailTextField;
///  注册
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.registButton.enabled = NO;
    
    //将registViewModel的XX属性和XX控件的文本输入信号绑定(rac_textSignal是别人已经封装好的)
    RAC(self.registViewModel,account) = self.accountTextField.rac_textSignal;
    RAC(self.registViewModel,password) = self.passwordTextField.rac_textSignal;
    RAC(self.registViewModel,email) = self.emailTextField.rac_textSignal;
    RAC(self.registViewModel,confirmEmail) = self.confirmEmailTextField.rac_textSignal;
    
    //就是当button被按下时会执行的一个命令，命令被执行完后可以返回一个signal，
    self.registButton.rac_command = self.registViewModel.registCommand;
    {
//    RAC(self.accountTextField,enabled) = [self.registViewModel.registCommand.executing not];
//    RAC(self.passwordTextField,enabled) = [self.registViewModel.registCommand.executing not];
//    RAC(self.emailTextField,enabled) = [self.registViewModel.registCommand.executing not];
//    RAC(self.confirmEmailTextField,enabled) = [self.registViewModel.registCommand.executing not];
    }
    //当networkActivityIndicatorVisible正在转菊花的时候,四个编辑框应该是不能编辑的
    RAC(self.accountTextField,enabled)  =  RAC(self.passwordTextField,enabled)  = RAC(self.emailTextField,enabled) = RAC(self.confirmEmailTextField,enabled)  = [self.registViewModel.registCommand.executing not];  //not取反
    {
    //能够注册的前提: 账户名和密码不能为空,且密码长度要大于6位;邮箱要和确认邮箱一样并且符合邮箱的格式

    //RAC(TARGET, [KEYPATH, [NIL_VALUE]])     总是在等号左边,右边是个RACSignal ,意义是将某个对象的属性,和一个信号绑定
    
    
    //账户名不为空,
//    RACSignal *accountSignal = [self.accountTextField.rac_textSignal map:^id(NSString *value) {
//        
//        NSString *pattern = @"^[A-Za-z0-9]+$";   // 字母数字
//        
//        return  @([value matchWithPattern:pattern]);
//        
//    }];
//    
//    NSLog(@"******%@******",[[self.accountTextField.rac_textSignal map:^id(NSString *value) {
//        
//        NSString *pattern = @"^[A-Za-z0-9]+$";   // 字母数字
//        
//        return  @([value matchWithPattern:pattern]);
//        
//    }] class]);
//    
//    //密码长度要大于等于6
//     RACSignal *passwordSignal  = [self.passwordTextField.rac_textSignal map:^id(NSString *value) {
//    
//        return  @(value.length >= 6);
//        
//    }];
    
    
//    //  邮箱格式要正确
//     RACSignal *emailSignal  = [self.emailTextField.rac_textSignal map:^id(NSString  *value) {
//        
//        NSString *pattern = @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
//        
//        return  @([value matchWithPattern:pattern]);
//    }];
//    
//    
//     RACSignal *confirmSignal  = [self.confirmEmailTextField.rac_textSignal map:^id(NSString *value) {
//        
//        return @([value isEqualToString:self.emailTextField.text]);
//        
//    }];
//    
//    RACSignal *emailTogetherSignal = [RACSignal combineLatest:@[self.emailTextField.rac_textSignal,self.confirmEmailTextField.rac_textSignal] reduce:^id(NSString *emailStr, NSString *confirmEmailStr){
//        
//        NSString *pattern = @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
//    
//        return @([emailStr matchWithPattern:pattern] && [emailStr isEqualToString:confirmEmailStr]) ;
//        
//    }];
//    
//    //combineLatest 组合   reduce聚合
//    RAC(self.registButton,enabled) = [RACSignal combineLatest:@[accountSignal,passwordSignal,emailTogetherSignal] reduce:^id(NSNumber *accountValue,NSNumber *passwordValue,NSNumber *emailValue){
//        
//        return @(accountValue.boolValue && passwordValue.boolValue && emailValue.boolValue);
//        
//    }];
    }
    
    //executing表示registCommand正在执行
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = self.registViewModel.registCommand.executing;
    
    @weakify(self)  //解决循环引用问题,成对出现
    [[self.registViewModel.registCommand.executionSignals delay:3] subscribeNext:^(id x) {
        @strongify(self)
        
        //保存到偏好设置里
        [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"accountKey"];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"passwordKey"];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoginViewController *loginVc = [sb instantiateViewControllerWithIdentifier:@"loginVC"];
        
        [self presentViewController:loginVc animated:YES completion:nil];
        
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];

}

- (RegistViewModel *)registViewModel {

    if (_registViewModel == nil) {
        _registViewModel = [[RegistViewModel alloc] init];
    }
    return _registViewModel;

}

@end
