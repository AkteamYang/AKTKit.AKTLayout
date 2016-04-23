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
    self.view.layoutActive = NO;
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
            // 添加内部子视图
            UIView *sub = [UIView new];
            [v addSubview:sub];
            sub.backgroundColor = mAKT_Color_Color(171, 64, 98, 1);
            [sub aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.centerXY.equalTo(akt_view(v));
                layout.size.equalTo(akt_view(v)).multiple(.33);
            }];
            // 添加一个同级别视图（跨级参考sub）
            UIView*v1 = [UIView new];
            [self.view addSubview:v1];
            v1.backgroundColor = mAKT_Color_Color(101, 89, 155, 1);
            [v1 aktLayout:^(AKTLayoutShellAttribute *layout) {
                layout.top.left.equalTo(akt_view(v));
                layout.right.equalTo(sub.akt_left);
                layout.bottom.equalTo(sub.akt_top);
            }];
            last = v;
            v.backgroundColor = mAKT_Color_Color(arc4random()%255, arc4random()%255, arc4random()%255, 1);
        }
    }
    b = [[NSDate new] timeIntervalSince1970];
    NSLog(@"%lf",b-a);
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
