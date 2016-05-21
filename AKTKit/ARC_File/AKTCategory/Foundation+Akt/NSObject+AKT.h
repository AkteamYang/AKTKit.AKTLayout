//
//  NSObject+AKT.h
//  Pursue
//
//  Created by YaHaoo on 16/4/5.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (AKT)
/*
 * Method swizzle for instance
 * Exchange origne method to a new method
 */
+ (BOOL)swizzleClass:(Class)cls fromMethod:(SEL)origneSelector toMethod:(SEL)newSelector;
@end
