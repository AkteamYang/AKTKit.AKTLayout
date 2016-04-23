//
//  AKTNavigationController.m
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTNavigationController.h"
#import "AKTNaviPopAnimation.h"
#import "AKTNaviPushAnimation.h"
#import "AKTInteractivePop.h"
#import "AKTViewController.h"

@interface AKTNavigationController ()
@property (strong, nonatomic) AKTNaviPopAnimation *popAnimation;
@property (strong, nonatomic) AKTNaviPushAnimation *pushAnimation;
@property (strong, nonatomic) AKTInteractivePop *interactivePop;
@end
@implementation AKTNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Don't adjust scrollView inset automatically.
    // 不自动调整scrollview插入值
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.delegate = self;
    _interactivePop = self.interactivePop;
    self.interactivePopGestureRecognizer.enabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarHidden = YES;
}
#pragma mark - property settings
//|---------------------------------------------------------
- (AKTNaviPushAnimation *)pushAnimation {
    if (_pushAnimation == nil) {
        _pushAnimation = [[AKTNaviPushAnimation alloc]initWithNv:self];
    }
    return _pushAnimation;
}

- (AKTNaviPopAnimation *)popAnimation {
    if (_popAnimation == nil) {
        _popAnimation = [[AKTNaviPopAnimation alloc]initWithNv:self];
    }
    return _popAnimation;
}

- (AKTInteractivePop *)interactivePop {
    if (_interactivePop == nil) {
        _interactivePop = [[AKTInteractivePop alloc]initWithViewController:self];
    }
    return _interactivePop;
}

- (void)setInteractiveGestureEnable:(BOOL)interactiveGestureEnable {
    _interactiveGestureEnable = interactiveGestureEnable;
    self.interactivePop.userInterfaceInteractive = interactiveGestureEnable;
}
#pragma mark - view settings
//|---------------------------------------------------------
/*
 * 旋转屏幕之后返回上一个界面时需要手动设置一下界面，有可能进入前和退出时方向时不一致的
 */
- (void)orientation:(UIInterfaceOrientation)toInterfaceOrientation {
    CGFloat width = mAKT_Device_Width;
    CGFloat height = mAKT_Device_Height;
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            self.view.frame = CGRectMake(0, 0, width, height);
            break;
        case UIInterfaceOrientationLandscapeLeft: case UIInterfaceOrientationLandscapeRight:
            self.view.frame = CGRectMake(0, 0, height, width);
            break;
        default:
            break;
    }
}
#pragma mark - delegate
//|---------------------------------------------------------
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0) {
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }else if(operation == UINavigationControllerOperationPop){
        return self.popAnimation;
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0) {
    if([animationController isKindOfClass:[AKTNaviPopAnimation class]]){
        return self.interactivePop.isInteracting? self.interactivePop:nil;
    }
    return nil;
}
@end
