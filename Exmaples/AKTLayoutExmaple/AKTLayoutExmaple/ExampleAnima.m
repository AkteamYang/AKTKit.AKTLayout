//
//  ExampleAnima.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/5/22.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExampleAnima.h"
#import "AKTKit.h"

@interface ExampleAnima ()
@property (strong, nonatomic) UIView *animaView;
@property (assign, nonatomic) BOOL animationStart;
@end

@implementation ExampleAnima
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view settings
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航
    self.view.aktName = @"self.view";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithImage:mAKT_Image_Origin(@"P_Back") style:(UIBarButtonItemStylePlain) target:self action:@selector(back)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithImage:mAKT_Image_Origin(@"P_Rotate") style:(UIBarButtonItemStylePlain) target:self action:@selector(rotate)]];
    [self layoutTest3];
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
    self.animaView = center2;
    
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
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rotate {
    self.animationStart = !self.animationStart;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithImage:mAKT_Image_Origin(self.animationStart? @"P_Stop":@"P_Rotate") style:(UIBarButtonItemStylePlain) target:self action:@selector(rotate)]];
    if (self.animationStart) {
        [self animation1WithView:self.animaView];
    }
}

- (void)animation1WithView:(UIView *)view {
    [UIView aktAnimation:^{
        [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:1.f initialSpringVelocity:.2 options:0 animations:^{
            [view aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.centerXY.equalTo(akt_view(self.view));
                layout.height.width.equalTo(self.view.akt_height).multiple(.4);
            }];
        } completion:^(BOOL finished) {
            [self animation2WithView:view];
        }];
    }];
}

- (void)animation2WithView:(UIView *)view {
    [UIView aktAnimation:^{
        [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:1.f initialSpringVelocity:.2 options:0 animations:^{
            [view aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.centerXY.equalTo(akt_view(self.view));
                layout.height.width.equalTo(self.view.akt_height).multiple(.2);
            }];
        } completion:^(BOOL finished) {
            if (!self.animationStart) {
                return ;
            }
            [self animation1WithView:view];
        }];
    }];
}
@end
