//
//  AKTViewController.h
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTNavigationBar.h"

@interface AKTViewController : UIViewController <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) AKTNavigationBar *naviBar;
@property (assign, nonatomic) BOOL interactiveGestureEnable;
- (void)orientation:(UIInterfaceOrientation)toInterfaceOrientation;
/*
 * Subviews need layout.
 */
- (void)aktViewLayoutUpdate;
/*
 * Current view controller was poped.
 */
- (void)viewControllerPoped;
@end
