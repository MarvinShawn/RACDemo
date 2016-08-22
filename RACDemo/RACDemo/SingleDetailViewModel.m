//
//  SingleDetailViewModel.m
//  RACDemo
//
//  Created by ww on 16/7/23.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "SingleDetailViewModel.h"


@implementation SingleDetailViewModel



- (instancetype)init {

    if (self = [super init]) {
     
        [self initBind];
        
    }
    return  self;
    
}

- (void)initBind {


    
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSString *url = @"http://open3.bantangapp.com/search/product/listByKeyword/?app_id=com.jzyd.BanTang&app_installtime=1468577067&app_versions=5.8.4&channel_name=appStore&client_id=bt_app_ios&client_secret=9c1e6634ce1c5098e056628cd66a17a5&device_token=053ca8e3c18a3f5b2612501cfd8ae08b9fe65e89ca1bfa31e5277bfb9c0e0d23&oauth_token=799a8cf8abd9695c607466cee1724e7d&os_versions=9.3.1&page=0&pagesize=20&screensize=750&track_device_info=iPhone8%2C1&track_deviceid=7FB00699-13A6-49CD-B423-742FDAA3B13C&track_user_id=2354378&v=16";

                //RACTupleUnpack：把RACTuple（元组类）解包成对应的数据
                RACTupleUnpack(NSNumber *tag,NSString *searchContent) = input;
            
            NSDictionary *dict = @{@"sort_type":tag.description, @"keyword": searchContent};
            
            [BTangSingleModel getSingleModelWtihUrlstr:url Paramer:dict Success:^(NSArray *responseBody) {

                self.goodsStatus = responseBody;
                
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted]; //这句要有,不然则表示subscriber一直在sendNext
                
            } Failure:^(NSError *error) {
                NSLog(@"%@",error);
                 [subscriber sendNext:@(NO)];
                 [subscriber sendCompleted]; //同上
            
            }];
        
            return nil;
        }];
        
    }];

}

-(NSArray *)goodsStatus {

    if (_goodsStatus == nil) {
        _goodsStatus = [[NSArray alloc] init];
    }
    return _goodsStatus;

}
@end
