//
//  LoginViewController.m
//  RACDemo
//
//  Created by ww on 16/7/21.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "LoginViewController.h"
#import "BTSingleDetailVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登陆";
    
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:@"accountKey"];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordKey"];
    
    {
//    RAC(self.loginButton,enabled) = [[[self.accountTextField.rac_textSignal map:^id(NSString *value) {
//        return @(value.length > 0);
//    }] combineLatestWith:[self.passwordTextField.rac_textSignal map:^id(NSString *value) {
//        return @(value.length > 0);
//    }]] reduceEach:^id(NSNumber *account, NSNumber *password){
//        return @(account.boolValue && password.boolValue);
//    }];
    }
    
    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:[[[self.accountTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 0);
    }] combineLatestWith:[self.passwordTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 0);
    }]] reduceEach:^id(NSNumber *account, NSNumber *password){
        return @(account.boolValue && password.boolValue);
    }] signalBlock:^RACSignal *(id input) {
    
        if ( [self.accountTextField.text isEqualToString:account] && [self.passwordTextField.text isEqualToString:password] ) {
            
            NSLog(@"登陆成功");
            
            BTSingleDetailVC *singleVc = [[BTSingleDetailVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:singleVc];
            [self presentViewController:nav animated:YES completion:nil];
            
        }else {
            
            NSLog(@"账号或密码有误");
            
        }
        
        return [RACSignal empty];
    }];
    
  
    

 
}



@end
