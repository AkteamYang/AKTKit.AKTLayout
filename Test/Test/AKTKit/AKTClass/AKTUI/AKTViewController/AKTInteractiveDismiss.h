//
//  AKTInteractiveDismiss.h
//  Pursue
//
//  Created by YaHaoo on 16/4/6.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKTInteractiveDismiss : UIPercentDrivenInteractiveTransition
@property (assign, nonatomic) BOOL isInteracting;
@property (assign, nonatomic) BOOL userInterfaceInteractive;
- (id)initWithViewController:(UIViewController *)vc;
@end
