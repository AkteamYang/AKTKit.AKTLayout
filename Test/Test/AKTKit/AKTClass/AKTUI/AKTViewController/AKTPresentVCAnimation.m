//
//  AKTPresentVCAnimation.m
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTPresentVCAnimation.h"
#import "AKTPublic.h"
#import "AKTDismissVCAnimation.h"
#import "AKTViewController.h"

@implementation AKTPresentVCAnimation
#pragma mark - delegate
//|---------------------------------------------------------
// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return kTimeinterval;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *container = transitionContext.containerView;
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([toVc isKindOfClass:[AKTViewController class]]) {
        AKTViewController *vc = (id)toVc;
        [vc orientation: fromVc.interfaceOrientation];
    }
    [container addSubview:fromVc.view];
    [container addSubview:toVc.view];
    toVc.view.frame = CGRectMake(0, mAKT_SCREENHEIGHT, mAKT_SCREENWITTH, mAKT_SCREENHEIGHT);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.5f options:0 animations:^{
        toVc.view.frame = CGRectMake(0, 0, mAKT_SCREENWITTH, mAKT_SCREENHEIGHT);
        fromVc.view.transform = CGAffineTransformMakeScale(.96, .96);
        fromVc.view.alpha = .8;
    } completion:^(BOOL finished) {
        fromVc.view.alpha = 1;
        fromVc.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:YES];
    }];
}
@end
