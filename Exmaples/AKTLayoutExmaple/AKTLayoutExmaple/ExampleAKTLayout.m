//
//  ExampleAKTLayout.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/5/22.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExampleAKTLayout.h"
#import "AKTKit.h"

//--------------------Structs statement, globle variables...--------------------
extern const int kColumns;
extern const int kLines;
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface ExampleAKTLayout ()

@end

@implementation ExampleAKTLayout
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
    // 加载AKTLayout
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initUIAkt];
    });
}

- (void)initUIAkt {
    double a, b;
    a = [[NSDate new] timeIntervalSince1970];
    NSLog(@"%lf",a-a);
    int lines = kLines, columns = kColumns;
    UIView *last;
    for (int i = 0; i<lines; i++) {
        for (int j = 0; j<columns; j++) {
            UIView *v = [[UIView alloc]init];
            [self.view addSubview:v];
            [v aktLayout:^(AKTLayoutShellAttribute *layout) {
                if(j == 0){
                    layout.left.equalTo(akt_view(self.view));
                }else{
                    layout.left.equalTo(last.akt_right);
                }
                layout.top.equalTo(self.view.akt_height).multiple(((float)i)/lines);
                layout.width.equalTo(akt_view(self.view)).multiple(1.f/columns);
                layout.height.equalTo(akt_view(self.view)).multiple(1.f/lines);
            }];
            //            v.aktName = @"akt_v";
            //            v.tag = (j+1)+(i*columns);
            // 添加内部子视图
            UIView *sub = [UIView new];
            [v addSubview:sub];
            sub.backgroundColor = mAKT_Color_Color(171, 64, 98, 1);
            [sub aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.centerXY.equalTo(akt_view(v));
                layout.size.equalTo(akt_view(v)).multiple(.33);
            }];
            //            sub.aktName = @"akt_sub";
            //            sub.tag = (j+1)+(i*columns);
            // 添加一个视图（跨级参考sub）
            UIView*v1 = [UIView new];
            [self.view addSubview:v1];
            v1.backgroundColor = mAKT_Color_Color(101, 89, 155, 1);
            [v1 aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.top.left.equalTo(akt_view(v));
                layout.right.equalTo(sub.akt_left);
                layout.bottom.equalTo(sub.akt_top);
            }];
            //            v1.aktName = @"akt_v1";
            //            v1.tag = (j+1)+(i*columns);
            // 添加一个视图（跨级参考sub、参考v1）
            UIView*v2 = [UIView new];
            [self.view addSubview:v2];
            v2.backgroundColor = mAKT_Color_Color(0, 89, 155, 1);
            [v2 aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.top.right.equalTo(akt_view(v));
                layout.height.equalTo(v1.akt_height);
                layout.left.equalTo(sub.akt_right);
            }];
            //            v2.aktName = @"akt_v2";
            //            v2.tag = (j+1)+(i*columns);
            // 添加一个视图（跨级参考sub、参考v1/v2）
            UIView*v3 = [UIView new];
            [self.view addSubview:v3];
            v3.backgroundColor = mAKT_Color_Color(101, 0, 155, 1);
            [v3 aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.top.equalTo(sub.akt_bottom);
                layout.left.equalTo(v1.akt_right);
                layout.right.equalTo(v2.akt_left);
                layout.bottom.equalTo(akt_view(self.view));
            }];
            //            v3.aktName = @"akt_v3";
            //            v3.tag = (j+1)+(i*columns);
            last = v;
            v.backgroundColor = mAKT_Color_Color(arc4random()%255, arc4random()%255, arc4random()%255, 1);
        }
    }
    [UIView aktScreenRotatingAnimationSupport:NO];
    b = [[NSDate new] timeIntervalSince1970];
    NSLog(@"%lf",b-a);
}

#pragma mark - click events
- (void)back {
    [UIView aktScreenRotatingAnimationSupport:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rotate {
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformRotate(self.view.transform, M_PI/2);
        self.view.frame = CGRectMake(0, 0, self.view.height, self.view.width);
    }];
}
@end
