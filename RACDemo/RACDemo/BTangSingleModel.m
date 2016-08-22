
#import "BTangSingleModel.h"
#import "MSNetworkSingleton.h"
#import "MJExtension.h"

@implementation BTangSingleModel

+ (instancetype)getSingleModelWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}


+(void)getSingleModelWtihUrlstr:(NSString*)url Paramer:(id)paramer Success:(successBlock)successBlock Failure:(failureBlock)failureBlock {

    NSAssert(successBlock != nil, @"完成回调不能为空");
    [[MSNetworkSingleton shareManager] postWithUrlStr:url Paramer:paramer Success:^(NSDictionary *responseBody) {
        
        NSArray *dataArr = responseBody[@"data"];
        
        successBlock([BTangSingleModel mj_objectArrayWithKeyValuesArray:dataArr].copy);
        
    } Failure:^(NSError *error) {
        
        !failureBlock ? : failureBlock(error);
        
    }];



}


@end
