//
//  AKTInteractivePop.h
//  Pursue
//
//  Created by YaHaoo on 16/4/7.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKTNavigationController;
@interface AKTInteractivePop : UIPercentDrivenInteractiveTransition
@property (assign, nonatomic) BOOL isInteracting;
@property (assign, nonatomic) BOOL userInterfaceInteractive;
- (id)initWithViewController:(AKTNavigationController *)vc;
@end
