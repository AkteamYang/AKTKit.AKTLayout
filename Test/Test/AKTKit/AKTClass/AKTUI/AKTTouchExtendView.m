//
//  AKTTouchExtendView.m
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/10.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import "AKTTouchExtendView.h"

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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event] && self.alpha*100>0 && !self.hidden) {
        return self.view;
    }else{
        return [super hitTest:point withEvent:event];
    }
}
@end
