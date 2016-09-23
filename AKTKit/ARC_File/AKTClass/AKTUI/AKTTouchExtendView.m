//
//  AKTTouchExtendView.m
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/10.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import "AKTTouchExtendView.h"
#import "UIView+AKTLayout.h"

@interface AKTTouchExtendView()
@property (weak, nonatomic) UIView *view;
@end
@implementation AKTTouchExtendView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithVeiw:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
    }
    return self;
}

/**
 *  创建一个触摸扩展视图
 *
 *  @param bindView 需要被扩展的view，view 需要被加入到父视图
 *  @param inset    相对于需要被扩展的view的边缘的距离
 */
+ (void)touchExtendForView:(UIView *)bindView extendInset:(UIEdgeInsets)inset {
    UIView *touch = [[AKTTouchExtendView alloc]initWithVeiw:bindView];
    [bindView.superview addSubview:touch];
    touch.frame = CGRectMake(bindView.x-inset.left, bindView.y-inset.top, bindView.width+inset.left+inset.right, bindView.height+inset.top+inset.bottom);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event] && self.alpha*100>0 && !self.hidden) {
        return self.view;
    }else{
        return [super hitTest:point withEvent:event];
    }
}
@end
