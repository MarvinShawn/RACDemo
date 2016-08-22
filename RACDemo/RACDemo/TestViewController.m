//
//  TestViewController.m
//  RACDemo
//
//  Created by ww on 16/7/26.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "TestViewController.h"
#import "ViewControllerTwo.h"
#import "PinkView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TestViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldThree;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFour;

@property (weak, nonatomic) IBOutlet UIButton *testButton;

@property (weak, nonatomic) IBOutlet PinkView *pinkView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 
    //textFieldOne输入什么,label显示什么
    //基于KVO
//    RAC(self.showLabel,text) = self.textFieldOne.rac_textSignal;

//    RAC(self.textFieldTwo,text) = self.textFieldOne.rac_textSignal;
//    RAC(self.textFieldOne,text) = self.textFieldTwo.rac_textSignal;
//    


    //    RACChannelTerminal *textFieldChannelT = textField.rac_newTextChannel;
    //    RAC(self.viewModel, property) = textFieldChannelT;
    //    [RACObserve(self.viewModel, property) subscribe:textFieldChannelT];
    
//        RACChannelTerminal *integerChannelT = self.textFieldTwo.rac_newTextChannel;
//        [integerChannelT sendNext:@"scascsc"]; // (1)
//    
//        [integerChannelT subscribeNext:^(id value) { // (2)
//            NSLog(@"value: %@", value);
//        }];
    
    RAC(self.testButton,enabled) = [self.textFieldOne.rac_textSignal map:^id(NSString *value) {
        
        return @([value isEqualToString:@"1"]);
        
    }];
    
    
    ///代替事件
    [[self.testButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ViewControllerTwo *vcTwo = [sb instantiateViewControllerWithIdentifier:@"VcTwo"];

        [self presentViewController:vcTwo animated:YES completion:nil];
    }];
    
    
    RAC(self.showLabel,text) = [self.pinkView.buttonClickSignal merge:self.textFieldOne.rac_textSignal];
  
//    [self.pinkView.buttonClickSignal subscribeNext:^(NSString *x) {
//        
//        NSLog(@"---------%@---------",x);
//        
//    }];
    
    
    
}




- (void)commonWay {

   [self.textFieldOne addTarget:self action:@selector(texting:) forControlEvents:UIControlEventEditingChanged];

}

- (void)texting:(UITextField *)textField {


    self.showLabel.text = textField.text;

}


- (void)signalCreat {

    
    //创建信号  -->  订阅信号,才会激活信号  -->  发送信号
    
    //创建信号
    RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //block调用时刻:每当有订阅者订阅信号的时候,就会调用block
        //发送信号
        [subscriber sendNext:@1];
        
        //如果不再发送数据,最好发送信号完成,内部会自动调用[RACDisposable disposable]取消订阅
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            //block调用时刻,当信号发送完成或者发送出错,就会自动执行这个block,取消订阅信号
            //执行完block后,当前信号就不在被订阅了
            NSLog(@"信号被销毁了");
        }];
        
    }];
    
    //订阅信号,才会激活信号
    [single subscribeNext:^(id x) { //nextBlock
        
        NSLog(@"接收到数据:%@",x);
        
    }];


}

/*
 ================ RACSignal使用步骤 ==================
//1.创建信号[RACSignal createSignal:<#^RACDisposable *(id<RACSubscriber> subscriber)didSubscribe#>];

//2.订阅信号,才会激活信号  - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock

//3.发送信号 - (void)sendNext:(id)value

 */


@end
