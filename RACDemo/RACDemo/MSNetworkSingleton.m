
#import "MSNetworkSingleton.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
@implementation MSNetworkSingleton

+(instancetype)shareManager{
    static MSNetworkSingleton *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singleton = [[self alloc] init];
    });
    return  singleton;
}


-(AFHTTPSessionManager *)AFNConfig{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.baseURL  这种是只读的
    //请求时长
    manager.requestSerializer.timeoutInterval = 30;
    //设置可接受的响应数据的格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    
    return manager;
    
}

-(void)postWithUrlStr:(NSString *)urlStr Paramer:(id)paramer Success:(successBlock)successBlock Failure:(failureBlock)failureBlock{
    
    //获取请求对象
    AFHTTPSessionManager *manager = [self AFNConfig];
    
   urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //真正发送请求的地方
    [manager POST:urlStr parameters:paramer progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];

}

-(void)getWithUrlStr:(NSString *)urlStr Paramer:(id)paramer Success:(successBlock)successBlock Failure:(failureBlock)failureBlock{
    
    AFHTTPSessionManager *manager = [self AFNConfig];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlStr parameters:paramer progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];
    
}








@end
