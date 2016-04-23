//
//  UIView+AKT.h
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/8.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AKT)
/*
 * Shake view animation
 */
+ (void)shakeAnimationWithView:(UIView *)view;

/*
 * Set the view disable, when disable is equal to YES, the view will be uninteractive.
 */
- (void)viewWaiting:(BOOL)waiting;
@end
