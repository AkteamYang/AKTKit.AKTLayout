//
//  AKTNavigationBar.m
//  Pursue
//
//  Created by YaHaoo on 16/4/7.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTNavigationBar.h"
#import "AKTPublic.h"
#import "UIView+AKTLayout.h"

@implementation AKTNavigationBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, mAKT_SCREENWITTH, 64);
        // Forced layout
        // 强制布局
        [self aktLayoutUpdate];
    }
    return self;
}
#pragma mark - super methods
//|---------------------------------------------------------
- (void)aktLayoutUpdate {
    // Layout subviews
    CGFloat topHeight = mAKT_EQ(self.width, mAKT_Device_Width)? 20:0;
    self.naviBackgroundImg.frame = CGRectMake(0, 0, self.superview.width, 44+topHeight);
    self.leftNaviBtn.frame = CGRectMake(10, topHeight, 54, 44);
    self.rightNaviBtn.frame = CGRectMake(self.superview.width-54-10,topHeight, 54, 44);
    [self.title aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerX.equalTo(akt_view(self));
        layout.left.equalTo(akt_value(64));
        layout.top.equalTo(akt_view(self)).offset(topHeight);
        layout.height.equalTo(akt_value(44));
    }];
}
#pragma mark - property settings
//|---------------------------------------------------------
- (UIImageView *)naviBackgroundImg {
    if (_naviBackgroundImg == nil) {
        _naviBackgroundImg = [UIImageView new];
        [self addSubview:_naviBackgroundImg];
        if (DEBUG_INFO_SHOW) {
            _naviBackgroundImg.backgroundColor = mAKT_Color_Random;
        }
    }
    return _naviBackgroundImg;
}

- (UIButton *)leftNaviBtn {
    if (_leftNaviBtn == nil) {
        _leftNaviBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:_leftNaviBtn];
        [_leftNaviBtn setTitleColor:mAKT_Color_Black forState:(UIControlStateNormal)];
        [_leftNaviBtn.titleLabel setFont:mAKT_Font_18];
        if (DEBUG_INFO_SHOW) {
            [_leftNaviBtn setBackgroundColor:mAKT_Color_Random];
        }
    }
    return _leftNaviBtn;
}

- (UIButton *)rightNaviBtn {
    if (_rightNaviBtn == nil) {
        _rightNaviBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:_rightNaviBtn];
        [_rightNaviBtn setTitleColor:mAKT_Color_Black forState:(UIControlStateNormal)];
        [_rightNaviBtn.titleLabel setFont:mAKT_Font_18];
        if (DEBUG_INFO_SHOW) {
            [_rightNaviBtn setBackgroundColor:mAKT_Color_Random];
        }
    }
    return _rightNaviBtn;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [UILabel new];
        [self addSubview:_title];
        [_title setFont:mAKT_Font_18];
        [_title setTextColor:mAKT_Color_Black];
        [_title setTextAlignment:(NSTextAlignmentCenter)];
        if (DEBUG_INFO_SHOW) {
            _title.backgroundColor = mAKT_Color_Random;
        }
    }
    return _title;
}
@end
