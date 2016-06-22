//
//  NavigationController.m
//  AKTLayoutExmaple
//
//  Created by HaoYang on 16/6/22.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.topViewController isKindOfClass:NSClassFromString(@"ExamplePlayer")]) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait |
    UIInterfaceOrientationMaskPortraitUpsideDown |
    UIInterfaceOrientationMaskLandscapeLeft |
    UIInterfaceOrientationMaskLandscapeRight;
}
@end
