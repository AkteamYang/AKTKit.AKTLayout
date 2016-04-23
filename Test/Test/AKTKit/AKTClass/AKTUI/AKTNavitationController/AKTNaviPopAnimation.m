//
//  AKTNaviPopAnimation.m
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTNaviPopAnimation.h"
#import "AKTDismissVCAnimation.h"
#import "AKTViewController.h"
#import "UIView+AKTLayout.h"
#import "AKTNavigationController.h"

@interface AKTNaviPopAnimation ()
@property (weak, nonatomic) AKTNavigationController *nv;
@end
@implementation AKTNaviPopAnimation
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
    return kTimeinterval+.1;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.nv.isAnimating = YES;
    UIView *container = transitionContext.containerView;
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [container addSubview:toVc.view];
    [container addSubview:fromVc.view];
    if ([toVc respondsToSelector:@selector(orientation:)]) {
        AKTViewController *vc = (id)toVc;
        [vc orientation: vc.interfaceOrientation];
    }
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
    
    fromVc.view.frame = CGRectMake(0, 0, fromVc.view.width, fromVc.view.height);
    toVc.view.transform = CGAffineTransformMakeScale(.96, .96);
    toVc.view.alpha = .8;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.5f options:0 animations:^{
        fromVc.view.frame = CGRectMake(fromVc.view.width, 0, fromVc.view.width, fromVc.view.height);
        toVc.view.alpha = 1;
        toVc.view.transform = CGAffineTransformIdentity;
        if (b) {
            fVc.naviBar.alpha = 0;
            tVc.naviBar.alpha = 1;
        }
    } completion:^(BOOL finished) {
        // 恢复缩放，因为需要还原初始状态，否则手势拖动取消时发生错误
        toVc.view.transform = CGAffineTransformIdentity;
        // 必须将fromVC的view位置复位，否则在取消状态下会出现显示错误
        fromVc.view.frame = CGRectMake(0, 0, fromVc.view.width, fromVc.view.height);
        if (b) {
            [fVc.view addSubview:fVc.naviBar];
            [tVc.view addSubview:tVc.naviBar];
            fVc.naviBar.alpha = 1;
            tVc.naviBar.alpha = 1;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        self.nv.isAnimating = NO;
    }];
}
@end
