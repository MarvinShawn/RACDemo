//
//  NSString+RegularExpression.h
//  正则表达式
//
//  Created by ww on 16/6/24.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpression)

//是否匹配
- (BOOL)matchWithPattern:(NSString *)pattern;



//返回range
- (NSRange)firstRangeMatchWithPattern:(NSString *)pattern;


//返回String

- (NSString *)firstStringMatchWithPattern:(NSString *)pattern;


/**
 *  返回Range数组
 *
 */
- (NSArray <NSValue *>* )matchesRangeWithPattern:(NSString *)pattern;


/**
 *  返回String数组
 *
 */
- (NSArray <NSString *> *)matchesStringWithPattern:(NSString *)pattern;


@end
