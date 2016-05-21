//
//  AKTNaviPushAnimation.m
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTNaviPushAnimation.h"
#import "AKTDismissVCAnimation.h"
#import "AKTViewController.h"
#import "AKTNavigationController.h"
#import "UIView+AKTLayout.h"

@interface AKTNaviPushAnimation ()
@property (weak, nonatomic) AKTNavigationController *nv;
@end
@implementation AKTNaviPushAnimation
- (instancetype)initWithNv:(AKTNavigationController *)nv
{
    self = [super init];
    if (self) {
        self.nv = nv;
    }
    return self;
}
// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return kTimeinterval;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.nv.isAnimating = YES;
    UIView *container = transitionContext.containerView;
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([toVc isKindOfClass:[AKTViewController class]]) {
        AKTViewController *vc = (id)toVc;
        [vc orientation: fromVc.interfaceOrientation];
    }
    [container addSubview:fromVc.view];
    [container addSubview:toVc.view];
    BOOL b = [fromVc isKindOfClass:[AKTViewController class]] && [toVc isKindOfClass:[AKTViewController class]];
    AKTViewController *fVc = (id)fromVc;
    AKTViewController *tVc = (id)toVc;
    if (b) {
        fVc = (id)fromVc;
        tVc = (id)toVc;
        [container addSubview:tVc.naviBar];
        [container addSubview:fVc.naviBar];
        tVc.naviBar.alpha = 0;
    }
    
    toVc.view.frame = CGRectMake(toVc.view.width, 0, toVc.view.width, toVc.view.height);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.5f options:0 animations:^{
        toVc.view.frame = CGRectMake(0, 0, toVc.view.width, toVc.view.height);
        fromVc.view.transform = CGAffineTransformMakeScale(.96, .96);
        fromVc.view.alpha = .8;
        if (b) {
            fVc.naviBar.alpha = 0;
            tVc.naviBar.alpha = 1;
        }
    } completion:^(BOOL finished) {
        fromVc.view.alpha = 1;
        fromVc.view.transform = CGAffineTransformIdentity;
        if (b) {
            [fVc.view addSubview:fVc.naviBar];
            [tVc.view addSubview:tVc.naviBar];
            fVc.naviBar.alpha = 1;
            tVc.naviBar.alpha = 1;
        }
        [transitionContext completeTransition:YES];
        self.nv.isAnimating = NO;
    }];
}

@end
