//
//  ViewController2.m
//  Test
//
//  Created by YaHaoo on 16/4/20.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController.h"

@interface ViewController2 ()
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Layout test
//    [self layoutTest1];
//    [self layoutTest2];
    [self layoutTest3];
    // Enter Performance Testing page
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        ViewController *v = [ViewController new];
//        [self presentViewController:v animated:YES completion:nil];
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - view settings
//|---------------------------------------------------------
/**
 *  Test 1
 */
- (void)layoutTest1 {
    CGFloat space = 10;
    UIView *v1 = [UIView new];
    [self.view addSubview:v1];
    v1.backgroundColor = mAKT_Color_Color(66, 171, 245, 1);
    [v1 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerY.equalTo(akt_view(self.view));
        layout.height.equalTo(akt_view(self.view)).multiple(.33);
        layout.left.equalTo(self.view.akt_left).offset(space);
        layout.right.equalTo(self.view.akt_centerX).offset(-space/2);
    }];
    
    UIView *v2 = [UIView new];
    [self.view addSubview:v2];
    v2.backgroundColor = mAKT_Color_Color(46, 194, 74, 1);
    [v2 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerY.equalTo(akt_view(self.view));
        layout.height.equalTo(akt_view(v1));
        layout.left.equalTo(v1.akt_right).offset(space);
        layout.right.equalTo(akt_view(self.view)).offset(-space);
    }];
    
    UIView *v3 = [UIView new];
    [self.view addSubview:v3];
    v3.backgroundColor = mAKT_Color_Color(244, 136, 51, 1);
    [v3 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.top.left.equalTo(akt_view(self.view)).offset(space);
        layout.right.equalTo(akt_view(self.view)).offset(-space);
        layout.bottom.equalTo(v1.akt_top).offset(-space);
    }];
    
    UIView *v4 = [UIView new];
    [self.view addSubview:v4];
    v4.backgroundColor = mAKT_Color_Color(233, 72, 89, 1);
    [v4 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.bottom.right.equalTo(akt_view(self.view)).offset(-space);
        layout.left.equalTo(akt_view(self.view)).offset(space);
        layout.top.equalTo(v1.akt_bottom).offset(space);
    }];
}

- (void)layoutTest2 {
    UIView *center = [UIView new];
    [self.view addSubview:center];
    center.backgroundColor = mAKT_Color_White;
    center.layer.borderColor = mAKT_Color_Background_230.CGColor;
    center.layer.borderWidth = 1;
    [center aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerXY.equalTo(akt_view(self.view));
        layout.height.width.equalTo(akt_value(150));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTest2:)];
    [center addGestureRecognizer:tap];
    
    UIImageView *center2 = [UIImageView new];
    [self.view addSubview:center2];
    center2.layer.borderColor = mAKT_Color_Background_230.CGColor;
    center2.layer.borderWidth = 1;
    center2.image = mAKT_Image(@"AKTLogo");
    center2.userInteractionEnabled = NO;
    [center2 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.edge.equalTo(akt_view(center)).edgeInset(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    UIView *v1 = [UIView new];
    [self.view addSubview:v1];
    v1.backgroundColor = mAKT_Color_Color(233, 72, 89, 1);
    [v1 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerY.equalTo(center.akt_centerY);
        layout.left.equalTo(self.view.akt_left);
        layout.right.equalTo(center.akt_left);
        layout.height.equalTo(akt_view(center)).multiple(.2);
    }];
    
    UIView *v2 = [UIView new];
    [self.view addSubview:v2];
    v2.backgroundColor = mAKT_Color_Color(46, 194, 74, 1);
    [v2 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerY.equalTo(center.akt_centerY);
        layout.right.equalTo(self.view.akt_right);
        layout.left.equalTo(center.akt_right);
        layout.height.equalTo(akt_view(center)).multiple(.2);
    }];

    UIView *v3 = [UIView new];
    [self.view addSubview:v3];
    v3.backgroundColor = mAKT_Color_Color(244, 136, 51, 1);
    [v3 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerX.equalTo(center.akt_centerX);
        layout.top.equalTo(self.view.akt_top);
        layout.bottom.equalTo(center.akt_top);
        layout.width.equalTo(akt_view(center)).multiple(.2);
    }];
    
    UIView *v4 = [UIView new];
    [self.view addSubview:v4];
    v4.backgroundColor = mAKT_Color_Color(66, 171, 245, 1);
    [v4 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerX.equalTo(center.akt_centerX);
        layout.bottom.equalTo(self.view.akt_bottom);
        layout.top.equalTo(center.akt_bottom);
        layout.width.equalTo(akt_view(center)).multiple(.2);
    }];
}

- (void)layoutTest3 {
    UIImageView *center2 = [UIImageView new];
    [self.view addSubview:center2];
    center2.layer.borderColor = mAKT_Color_Color(0, 187, 255, 1).CGColor;
    center2.layer.borderWidth = 1;
    center2.image = mAKT_Image(@"AKTLogo");
    center2.userInteractionEnabled = NO;
    [center2 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerXY.equalTo(akt_view(self.view));
        layout.width.height.equalTo(self.view.akt_width).multiple(.3);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTest3:)];
    [center2 addGestureRecognizer:tap];
    center2.userInteractionEnabled = YES;
    
    UIView *v1 = [UIView new];
    [self.view addSubview:v1];
    v1.backgroundColor = mAKT_Color_Color(233, 72, 89, 1);
    [v1 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.top.left.equalTo(akt_view(self.view));
        layout.bottom.equalTo(center2.akt_top);
        layout.right.equalTo(center2.akt_left);
    }];
    UIView *sub1 = [UIView new];
    [v1 addSubview:sub1];
    sub1.backgroundColor = mAKT_Color_White;
    [sub1 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.top.equalTo(v1.akt_centerY);
        layout.left.equalTo(v1.akt_centerX);
        layout.bottom.right.equalTo(akt_view(v1)).offset(-1);
    }];
    
    UIView *v2 = [UIView new];
    [self.view addSubview:v2];
    v2.backgroundColor = mAKT_Color_Color(46, 194, 74, 1);
    [v2 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.left.bottom.equalTo(akt_view(self.view));
        layout.top.equalTo(center2.akt_bottom);
        layout.right.equalTo(center2.akt_left);
    }];
    UIView *sub2 = [UIView new];
    [v2 addSubview:sub2];
    sub2.backgroundColor = mAKT_Color_White;
    [sub2 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.bottom.equalTo(v2.akt_centerY);
        layout.left.equalTo(v2.akt_centerX);
        layout.top.equalTo(akt_view(v2)).offset(1);
        layout.right.equalTo(akt_view(v2)).offset(-1);
    }];
    
    UIView *v3 = [UIView new];
    [self.view addSubview:v3];
    v3.backgroundColor = mAKT_Color_Color(244, 136, 51, 1);
    [v3 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.right.bottom.equalTo(akt_view(self.view));
        layout.top.equalTo(center2.akt_bottom);
        layout.left.equalTo(center2.akt_right);
    }];
    UIView *sub3 = [UIView new];
    [v3 addSubview:sub3];
    sub3.backgroundColor = mAKT_Color_White;
    [sub3 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.bottom.equalTo(v3.akt_centerY);
        layout.right.equalTo(v3.akt_centerX);
        layout.top.left.equalTo(akt_view(v3)).offset(1);
    }];
    
    UIView *v4 = [UIView new];
    [self.view addSubview:v4];
    v4.backgroundColor = mAKT_Color_Color(66, 171, 245, 1);
    [v4 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.top.right.equalTo(akt_view(self.view));
        layout.bottom.equalTo(center2.akt_top);
        layout.left.equalTo(center2.akt_right);
    }];
    UIView *sub4 = [UIView new];
    [v4 addSubview:sub4];
    sub4.backgroundColor = mAKT_Color_White;
    [sub4 aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.top.equalTo(v4.akt_centerY);
        layout.right.equalTo(v4.akt_centerX);
        layout.bottom.equalTo(akt_view(v4)).offset(-1);
        layout.left.equalTo(akt_view(v4)).offset(1);
    }];
}
#pragma mark - click events
//|---------------------------------------------------------
- (void)tapTest2:(UITapGestureRecognizer *)tap {
    if (tap.view.width>150) {
        [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.2 options:0 animations:^{
            tap.enabled = NO;
            tap.view.frame = CGRectMake((self.view.width-150)/2, (self.view.height-150)/2, 150, 150);
        } completion:^(BOOL finished) {
            tap.enabled = YES;
        }];
    }else{
        [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.2 options:0 animations:^{
            tap.enabled = NO;
            [tap.view aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.centerXY.equalTo(akt_view(self.view));
                layout.height.width.equalTo(akt_value(200));
            }];
        } completion:^(BOOL finished) {
            tap.enabled = YES;
        }];
    }
}

- (void)tapTest3:(UITapGestureRecognizer *)tap {
    [self animation1WithView:tap.view];
    tap.enabled = NO;
}
- (void)animation1WithView:(UIView *)view {
    [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:1.f initialSpringVelocity:.2 options:0 animations:^{
        [view aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.centerXY.equalTo(akt_view(self.view));
            layout.height.width.equalTo(self.view.akt_width).multiple(.6);
        }];
    } completion:^(BOOL finished) {
        [self animation2WithView:view];
    }];
}

- (void)animation2WithView:(UIView *)view {
    [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:1.f initialSpringVelocity:.2 options:0 animations:^{
        [view aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.centerXY.equalTo(akt_view(self.view));
            layout.height.width.equalTo(self.view.akt_width).multiple(.2);
        }];
    } completion:^(BOOL finished) {
        [self animation1WithView:view];
    }];
}
@end
