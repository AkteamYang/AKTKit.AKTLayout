//
//  AKTPopVCAnimation.m
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTDismissVCAnimation.h"
#import "AKTPublic.h"
#import "AKTViewController.h"
#import "UIView+AKTLayout.h"

@implementation AKTDismissVCAnimation
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
    if ([toVc respondsToSelector:@selector(orientation:)]) {
        AKTViewController *vc = (id)toVc;
        [vc orientation: vc.interfaceOrientation];
    }
    [container addSubview:toVc.view];
    [container addSubview:fromVc.view];
    fromVc.view.frame = CGRectMake(0, 0, mAKT_SCREENWITTH, mAKT_SCREENHEIGHT);
    toVc.view.transform = CGAffineTransformMakeScale(.96, .96);
    toVc.view.alpha = .8;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.5f options:0 animations:^{
        fromVc.view.frame = CGRectMake(0, mAKT_SCREENHEIGHT, mAKT_SCREENWITTH, mAKT_SCREENHEIGHT);
        toVc.view.alpha = 1;
        toVc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView aktAnimation:^{
            // 恢复缩放，因为需要还原初始状态，否则手势拖动取消时发生错误
            toVc.view.transform = CGAffineTransformIdentity;
            // 必须将fromVC的view位置复位，否则在取消状态下会出现显示错误
            fromVc.view.frame = CGRectMake(0, 0, fromVc.view.width, fromVc.view.height);
            if(![transitionContext transitionWasCancelled]){
                //            [fromVc.view removeFromSuperview];
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
}
@end
