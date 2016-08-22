//
//  HMNetworkSingleton.h
//  04网络考试
//
//  Created by 夏以铭 on 16/6/18.
//  Copyright © 2016年 夏以铭. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^successBlock)(id responseBody);
typedef void (^failureBlock)(NSError *error);

@interface MSNetworkSingleton : NSObject

+(instancetype)shareManager;

/**
 *  POST请求
 *
 *  @param urlStr       请求urlstr
 *  @param paramer      请求参数
 *  @param successBlock 成功block
 *  @param failureBlock 失败block
 */
-(void)postWithUrlStr:(NSString *)urlStr Paramer:(id)paramer Success:(successBlock)successBlock Failure:(failureBlock)failureBlock;
    
    
    
/**
 *  Get请求
 *
 *  @param urlStr       请求urlstr
 *  @param paramer      请求参数
 *  @param successBlock 成功block
 *  @param failureBlock 失败block
 */
-(void)getWithUrlStr:(NSString *)urlStr Paramer:(id)paramer Success:(successBlock)successBlock Failure:(failureBlock)failureBlock;


@end
