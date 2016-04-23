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
    [self layoutTest2];
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
@end
