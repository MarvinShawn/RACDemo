//
//  NSString+RegularExpression.m
//  正则表达式
//
//  Created by ww on 16/6/24.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString (RegularExpression)

/**
 *  判断是否匹配
 *
 */
- (BOOL)matchWithPattern:(NSString *)pattern {

    NSTextCheckingResult *result = [self firstMatchesWithPattern:pattern];
    
    if (result == nil) {
        return  NO;
    }
    
    return YES;
}


//返回range
- (NSRange)firstRangeMatchWithPattern:(NSString *)pattern {

    NSTextCheckingResult *result = [self firstMatchesWithPattern:pattern];
    
    if (result == nil) {
        return NSMakeRange(0, 0);
    }
    
    
    return result.range;

}
//返回String

- (NSString *)firstStringMatchWithPattern:(NSString *)pattern {

    NSTextCheckingResult *result = [self firstMatchesWithPattern:pattern];
    
    if (result == nil) {
        return nil;
    }

    return  [self substringWithRange:result.range];

}

/**
 *  返回Range数组
 *
 */
- (NSArray <NSValue *>* )matchesRangeWithPattern:(NSString *)pattern {


    NSArray <NSTextCheckingResult *> *resultArray = [self matchesWithPattren:pattern];

    if (resultArray.count == 0) {
        return nil;
    }
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:resultArray.count];
    for (NSTextCheckingResult *result in resultArray) {
        
        [tmpArr addObject:[NSValue valueWithRange:result.range]];
        
    }
    
    return tmpArr.copy;

}

/**
 *  返回String数组
 *
 */
- (NSArray <NSString *> *)matchesStringWithPattern:(NSString *)pattern {


    NSArray <NSTextCheckingResult *>*resultArray = [self matchesWithPattren:pattern];
    
    if (resultArray.count == 0) {
        return nil;
    }

    NSMutableArray *tmpArray =[NSMutableArray arrayWithCapacity:resultArray.count];
    
    for (NSTextCheckingResult *result in resultArray) {
        
        [tmpArray addObject:[self substringWithRange:result.range]];
        
    }
    
    
    return tmpArray.copy;

}

/**
 *  根据正则表达式来匹配字符串,只返回第一个匹配上的
 */
- (NSTextCheckingResult *)firstMatchesWithPattern:(NSString *)pattern {


    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (error) {
        NSLog(@"%@",error);
        return nil;
    }
    
    NSTextCheckingResult *result = [expression firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return result;

}


/**
 *
 *根据正则表达式来匹配,返回多个结果
 */

- (NSArray <NSTextCheckingResult *>*)matchesWithPattren:(NSString*)pattern {

    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (error) {
        NSLog(@"%@",error);
        return nil;
    }
    
    NSArray <NSTextCheckingResult *> *resultArray = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return resultArray;

}

@end
