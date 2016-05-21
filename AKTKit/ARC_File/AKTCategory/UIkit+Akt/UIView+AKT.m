//
//  UIView+AKT.m
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/8.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import "UIView+AKT.h"
#import "AKTKit.h"

@implementation UIView (AKT)
/*
 * Shake view animation
 */
+ (void)shakeAnimationWithView:(UIView *)view
{
    CGRect rec = view.frame;
    view.frame = CGRectMake(view.frame.origin.x+20, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:.02f initialSpringVelocity:0.001f options:(UIViewAnimationOptionAllowUserInteraction) animations:^{
        view.frame = rec;
    } completion:^(BOOL finished) {
        nil;
    }];
}

/*
 * Set the view disable, when disable is equal to YES, the view will be uninteractive.
 */
- (void)viewWaiting:(BOOL)waiting {
    UIView *view = [self viewWithTag:111111];
    if (waiting) {
        if (view) {
            return;
        }
        self.layer.masksToBounds = YES;
        UIView *mask = [UIView new];
        [self addSubview:mask];
        mask.backgroundColor = mAKT_Color_Color(255, 255, 255, .5);
        mask.frame = self.bounds;
        mask.tag = 111111;
        mask.alpha = 0;
        [UIView animateWithDuration:.15 animations:^{
            mask.alpha = 1;
        }];
        self.userInteractionEnabled = NO;
        return;
    }
    if (!view) {
        return;
    }
    [UIView animateWithDuration:.15 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        self.userInteractionEnabled = YES;
    }];
}
@end
