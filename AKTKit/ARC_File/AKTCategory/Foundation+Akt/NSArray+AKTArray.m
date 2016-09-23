//
//  NSArray+AKTArray.m
//  ting
//
//  Created by HaoYang on 16/9/5.
//  Copyright © 2016年 ximalaya Inc. All rights reserved.
//

#import "NSArray+AKTArray.h"

@implementation NSArray (AKTArray)
- (id)objectMaybeAtIndex:(NSUInteger)index {
    if (index<self.count) {
        return self[index];
    }
    return nil;
}
@end

@implementation NSMutableArray (AKTArray)
- (void)addOptionalObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

- (void)insertOptionalObjet:(id)object maybeAtIndex:(NSUInteger)index {
    if (object
        && (index<=self.count)) {
        [self insertObject:object atIndex:index];
    }
}

- (void)removeObjectMaybeAtIndex:(NSUInteger)index {
    if (index<self.count) {
        [self removeObjectAtIndex:index];
    }
}
@end
