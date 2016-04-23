//
//  NSObject+AKT.m
//  Pursue
//
//  Created by YaHaoo on 16/4/5.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "NSObject+AKT.h"

@implementation NSObject (AKT)
#pragma mark - runtime
//|---------------------------------------------------------
/*
 * Method swizzle for instance
 * Exchange origne method to a new method
 */
+ (BOOL)swizzleClass:(Class)cls fromMethod:(SEL)origneSelector toMethod:(SEL)newSelector {
    // Safty check
    if (!(cls && origneSelector && newSelector)) {
        return NO;
    }
    Method origneMethod = class_getInstanceMethod(cls, origneSelector);
    Method newMethod = class_getInstanceMethod(cls, newSelector);
    // If we can't get the values of newMethod and origneMethod, return NO for exit.
    if (!(origneMethod && newMethod)) {
        return NO;
    }
    // Exchange method.
    //    method_exchangeImplementations(origneMethod, newMethod);
    IMP origneImp = class_getMethodImplementation(cls, origneSelector);
    IMP newImp = class_getMethodImplementation(cls, newSelector);
    class_replaceMethod(cls, origneSelector, newImp, method_getTypeEncoding(newMethod));
    class_replaceMethod(cls, newSelector, origneImp, method_getTypeEncoding(origneMethod));
    return YES;
}
@end
