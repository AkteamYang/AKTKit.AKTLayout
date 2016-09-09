//
//  NSArray+AKTArray.h
//  ting
//
//  Created by HaoYang on 16/9/5.
//  Copyright © 2016年 ximalaya Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AKTArray)
- (id)objectMaybeAtIndex:(NSUInteger)index;
@end

@interface NSMutableArray (AKTMutableArray)
- (void)addOptionalObject:(id)object;

- (void)insertOptionalObjet:(id)object maybeAtIndex:(NSUInteger)index;

- (void)removeObjectMaybeAtIndex:(NSUInteger)index;
@end
