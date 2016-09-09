//
//  NSDictionary+AKTDic.m
//  ting
//
//  Created by HaoYang on 16/9/5.
//  Copyright © 2016年 ximalaya Inc. All rights reserved.
//

#import "NSDictionary+AKTDic.h"

BOOL objExist(id obj) {
    if (obj) {
        if ([obj isKindOfClass:[NSNull class]]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

@implementation NSDictionary (AKTDic)
- (NSDictionary *)dictionaryMaybeForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id obj = self[key];
    return [obj isKindOfClass:[NSDictionary class]]? obj:nil;
}

- (NSArray *)arrayMaybeForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id obj = self[key];
    return [obj isKindOfClass:[NSArray class]]? obj:nil;
}

- (NSString *)stringMaybeForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id obj = self[key];
    return [obj isKindOfClass:[NSString class]]? obj:nil;
}

- (NSNumber *)numberMaybeForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    id obj = self[key];
    return [obj isKindOfClass:[NSNumber class]]? obj:nil;
}

- (BOOL)boolMaybeForKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    id obj = self[key];
    NSNumber *num = [obj isKindOfClass:[NSNumber class]]? obj:nil;
    return [num boolValue];
}

- (NSInteger)integerMaybeForKey:(NSString *)key {
    if (!key) {
        return 0;
    }
    id obj = self[key];
    NSNumber *num = [obj isKindOfClass:[NSNumber class]]? obj:nil;
    return [num integerValue];
}

- (double)doubleMaybeForKey:(NSString *)key {
    if (!key) {
        return 0;
    }
    id obj = self[key];
    NSNumber *num = [obj isKindOfClass:[NSNumber class]]? obj:nil;
    return [num doubleValue];
}
@end

@implementation NSMutableDictionary (AKTMutableDic)

@end
