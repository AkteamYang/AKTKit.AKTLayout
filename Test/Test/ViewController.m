//
//  ViewController.m
//  Test
//
//  Created by YaHaoo on 16/4/16.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ViewController.h"
#import "AKTPublic.h"
#import "UIView+AKTLayout.h"
#import "Masonry.h"

#define kColumns 20
#define kLines 30
@interface ViewController ()
@property (strong, nonatomic) UIView *red;
@end

@implementation ViewController
#pragma mark - life cycle
//|---------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviBar.hidden = YES;
    self.view.aktName = @"self.view";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self initUI];
        [self initUIAkt];
//                    [self initUIMas];
    });
}
- (void)tap:(UITapGestureRecognizer *)tap {
    UIViewController *supVC = self.presentingViewController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ViewController *v = [ViewController new];
        [supVC presentViewController:v animated:YES completion:nil];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    mAKT_Log(@"%@_dealloc",NSStringFromClass(self.class));
}
#pragma mark - view settings
//|---------------------------------------------------------------------------------------------------------------------------
- (void)initUI {
    double a, b;
    a = [[NSDate new] timeIntervalSince1970];
    NSLog(@"%lf",a-a);
    int lines = kLines, columns = kColumns;
    CGFloat spaceW = mAKT_SCREENWITTH/(CGFloat)columns;
    CGFloat spaceH = mAKT_SCREENHEIGHT/(CGFloat)lines;
    for (int i = 0; i<lines; i++) {
        for (int j = 0; j<columns; j++) {
            UIView *v = [UIView new];
            [self.view addSubview:v];
            v.frame = CGRectMake(spaceW*j, spaceH*i, spaceW, spaceH);
            v.backgroundColor = mAKT_Color_Color(arc4random()%255, arc4random()%255, arc4random()%255, 1);
            // 添加内部子视图
            UIView *sub = [UIView new];
            [v addSubview:sub];
            sub.backgroundColor = mAKT_Color_Color(171, 64, 98, 1);
            CGSize size = CGSizeMake(v.width*.33, v.height*.33);
            sub.frame = CGRectMake((v.width-size.width)/2, (v.height-size.height)/2, size.width, size.height);
            // 添加一个同级别视图（跨级参考sub）
            UIView*v1 = [UIView new];
            [self.view addSubview:v1];
            v1.backgroundColor = mAKT_Color_Color(101, 89, 155, 1);
            v1.frame = CGRectMake(v.x, v.y, (v.width-sub.width)/2, (v.height-sub.height)/2);
        }
    }
    b = [[NSDate new] timeIntervalSince1970];
    NSLog(@"%lf",b-a);
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
//    for(UIView *v in [[self.view viewWithTag:5] layoutChain]){
//        NSLog(@"akt tag: %ld name: %@", v.tag, v.aktName);
//    }
}

- (void)initUIMas {
    double a, b;
    a = [[NSDate new] timeIntervalSince1970];
    NSLog(@"%lf",a-a);
    int lines = kLines, columns = kColumns;
    UIView *last;
    UIView *lastLine;
    for (int i = 0; i<lines; i++) {
        for (int j = 0; j<columns; j++) {
            UIView *v = [UIView new];
            [self.view addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                if(j == 0){
                    make.left.equalTo(self.view);
                }else{
                    make.left.equalTo(last.mas_right);
                }
                if (i==0) {
                    make.top.equalTo(self.view);
                }else{
                    make.top.equalTo(lastLine.mas_bottom);
                }
                make.width.equalTo(self.view).multipliedBy(1.f/columns);
                make.height.equalTo(self.view).multipliedBy(1.f/lines);
            }];
            // 添加内部子视图
            UIView *sub = [UIView new];
            [v addSubview:sub];
            sub.backgroundColor = mAKT_Color_Color(171, 64, 98, 1);
            [sub mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(v);
                make.size.equalTo(v).multipliedBy(.33);
            }];
            // 添加一个同级别视图（跨级参考sub）
            UIView*v1 = [UIView new];
            [self.view addSubview:v1];
            v1.backgroundColor = mAKT_Color_Color(101, 89, 155, 1);
            [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(v);
                make.right.equalTo(sub.mas_left);
                make.bottom.equalTo(sub.mas_top);
            }];
            // 添加一个视图（跨级参考sub、参考v1）
            UIView*v2 = [UIView new];
            [self.view addSubview:v2];
            v2.backgroundColor = mAKT_Color_Color(0, 89, 155, 1);
            [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(v);
                make.height.equalTo(v1.mas_height);
                make.left.equalTo(sub.mas_right);
            }];
            // 添加一个视图（跨级参考sub、参考v1/v2）
            UIView*v3 = [UIView new];
            [self.view addSubview:v3];
            v3.backgroundColor = mAKT_Color_Color(101, 0, 155, 1);
            [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sub.mas_bottom);
                make.left.equalTo(v1.mas_right);
                make.right.equalTo(v2.mas_left);
                make.bottom.equalTo(self.view);
            }];
            last = v;
            if (j==columns-1) {
                lastLine = v;
            }
            v.backgroundColor = mAKT_Color_Color(arc4random()%255, arc4random()%255, arc4random()%255, 1);
        }
    }
    b = [[NSDate new] timeIntervalSince1970];
    NSLog(@"%lf",b-a);
}
@end
