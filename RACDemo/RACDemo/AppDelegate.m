//
//  AppDelegate.m
//  RACDemo
//
//  Created by ww on 16/7/20.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RegistViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    //登陆控制器
    LoginViewController *loginVc = [sb instantiateViewControllerWithIdentifier:@"loginVC"];
   
    //注册控制器
    RegistViewController *registVc = [sb instantiateViewControllerWithIdentifier:@"registVC"];
    
    
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountKey"];
    
    UINavigationController *nav  = [[UINavigationController alloc] initWithRootViewController:account == nil ? registVc : loginVc];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
