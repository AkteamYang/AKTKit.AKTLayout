//
//  NSDictionary+AKTDic.h
//  ting
//
//  Created by HaoYang on 16/9/5.
//  Copyright © 2016年 ximalaya Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AKTDic)

- (NSDictionary *)dictionaryMaybeForKey:(NSString *)key;

- (NSArray *)arrayMaybeForKey:(NSString *)key;

- (NSString *)stringMaybeForKey:(NSString *)key;

- (NSNumber *)numberMaybeForKey:(NSString *)key;

- (BOOL)boolMaybeForKey:(NSString *)key;

- (NSInteger)integerMaybeForKey:(NSString *)key;

- (double)doubleMaybeForKey:(NSString *)key;

@end

@interface NSMutableDictionary (AKTMutableDic)

@end

