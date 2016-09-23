//
//  AKTTouchExtendView.h
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/10.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKTTouchExtendView : UIView
- (id)initWithVeiw:(UIView *)view;

/**
 *  创建一个触摸扩展视图
 *
 *  @param bindView 需要被扩展的view，view 需要被加入到父视图
 *  @param inset    相对于需要被扩展的view的边缘的距离
 */
+ (void)touchExtendForView:(UIView *)bindView extendInset:(UIEdgeInsets)inset;
@end
