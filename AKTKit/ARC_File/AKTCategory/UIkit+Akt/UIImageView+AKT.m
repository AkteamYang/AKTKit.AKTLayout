//
//  UIImageView+AKT.m
//  Test
//
//  Created by YaHaoo on 16/5/28.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "UIImageView+AKT.h"
#import "NSObject+AKT.h"
#import "UIView+AKTLayout.h"

@implementation UIImageView (AKT)
#pragma mark - super method
//|---------------------------------------------------------
/*
 * Do something before initialization.
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Exchange "setText:" to "aktText:"
        [UIImageView swizzleClass:[UIImageView class] fromMethod:@selector(setImage:) toMethod:@selector(aktImage:)];
    });
}
#pragma mark - property settings
//|---------------------------------------------------------
/*
 * The method was exchaged to method "setImage:" in the initialization of a label. So when we call "aktImage:" in actually calling "setImage:".
 */
- (void)aktImage:(UIImage *)image {
    // Set image
    [self aktImage:image];
    
    // Setting all of them to NO means that the frame cann't change, just return.
    if (self.adaptiveHeight == nil && self.adaptiveWidth == nil) {
        return;
    }
    if (self.adaptiveWidth.boolValue == NO && self.adaptiveHeight.boolValue == NO) {
        return;
    }
    [self sizeToFit];
    // Update aktLayout
    [self setNeedAKTLayout];
}
@end
