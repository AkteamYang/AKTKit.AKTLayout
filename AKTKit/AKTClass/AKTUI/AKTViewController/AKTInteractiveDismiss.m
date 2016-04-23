//
//  AKTInteractiveDismiss.m
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTInteractiveDismiss.h"
#import "AKTPublic.h"
@interface AKTInteractiveDismiss () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) UIViewController *rootVC;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (assign, nonatomic) CGFloat percent;
@end
@implementation AKTInteractiveDismiss
#pragma mark - life cycle
//|---------------------------------------------------------
- (instancetype)initWithViewController:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        self.rootVC = vc;
        [self initialize];
    }
    return self;
}
#pragma mark - property settings
//|---------------------------------------------------------
- (UIPanGestureRecognizer *)pan {
    if (_pan == nil) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self.rootVC.view addGestureRecognizer:_pan];
        _pan.delegate = self;
        _userInterfaceInteractive = YES;
    }
    return _pan;
}

- (void)setUserInterfaceInteractive:(BOOL)userInterfaceInteractive {
    _userInterfaceInteractive = userInterfaceInteractive;
    self.pan.enabled = userInterfaceInteractive;
}
#pragma mark - universal methods
//|---------------------------------------------------------
- (void)initialize {
    _pan = self.pan;
}
#pragma mark - click events
//|---------------------------------------------------------
- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.rootVC.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.isInteracting = YES;
        [self.rootVC dismissViewControllerAnimated:YES completion:nil];
    }else if(pan.state == UIGestureRecognizerStateChanged) {
        if (point.y>0) {
            self.percent = (point.y/mAKT_SCREENWITTH);
            [self updateInteractiveTransition:self.percent];
        }
    }else if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled) {
        if (self.percent>.07) {
            self.completionSpeed = .8;
            [self finishInteractiveTransition];
        }else{
            self.completionSpeed = 0.08;
            [self cancelInteractiveTransition];
        }
        self.isInteracting = NO;
    }
}
#pragma mark - delegate
//|---------------------------------------------------------
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // The presence of the navigation controller, using navigation controller gestures
    // 存在导航控制器时，启用导航控制器手势
    if (self.rootVC.navigationController) {
        return NO;
    }
    // No navigation controller, their own gesture-enabled, and in the case has been presented.
    // 没有时启用自己手势，并且在已被推出的情况下
    if (self.rootVC.presentingViewController) {
        return YES;
    }
    return NO;
}
@end
