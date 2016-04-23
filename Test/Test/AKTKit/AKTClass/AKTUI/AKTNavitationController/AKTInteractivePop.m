//
//  AKTInteractivePop.m
//  Pursue
//
//  Created by YaHaoo on 16/4/7.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTInteractivePop.h"
#import "AKTPublic.h"
#import "AKTNavigationController.h"

@interface AKTInteractivePop () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) AKTNavigationController *rootVC;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (assign, nonatomic) CGFloat percent;
@end
@implementation AKTInteractivePop
#pragma mark - life cycle
//|---------------------------------------------------------
- (instancetype)initWithViewController:(AKTNavigationController *)vc
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
        [self.rootVC popViewControllerAnimated:YES];
    }else if(pan.state == UIGestureRecognizerStateChanged) {
        if (point.x>0) {
            self.percent = (.15*point.x/mAKT_SCREENWITTH);
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
    if (self.rootVC.isAnimating) {
        return NO;
    }
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    return self.rootVC.viewControllers.count>1? YES:NO;
}
@end

