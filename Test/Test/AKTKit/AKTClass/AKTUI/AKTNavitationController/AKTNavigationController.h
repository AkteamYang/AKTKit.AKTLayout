//
//  AKTNavigationController.h
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTViewController.h"

@interface AKTNavigationController : UINavigationController <UINavigationControllerDelegate>
@property (assign, nonatomic) BOOL isAnimating;
@property (assign, nonatomic) BOOL interactiveGestureEnable;
/*
 * 旋转屏幕之后返回上一个界面时需要手动设置一下界面，有可能进入前和退出时方向时不一致的
 */
- (void)orientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
