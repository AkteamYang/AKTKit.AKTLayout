//
//  AKTNaviPopAnimation.h
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKTPublic.h"

@class AKTNavigationController;
@interface AKTNaviPopAnimation : NSObject <UIViewControllerAnimatedTransitioning>
- (instancetype)initWithNv:(AKTNavigationController *)nv;
@end
