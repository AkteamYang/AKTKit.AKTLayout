//
//  ExampleMasonry.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/5/22.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExampleMasonry.h"
#import "AKTKit.h"
#import "Masonry.h"

//--------------------Structs statement, globle variables...--------------------
#if TARGET_IPHONE_SIMULATOR
    const int kColumns = 15;
    const int kLines = 30;
#else 
    const int kColumns = 10;
    const int kLines = 30;
#endif
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface ExampleMasonry ()
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation ExampleMasonry
#pragma mark - property settings
//|---------------------------------------------------------
- (UIActivityIndicatorView *)indicator {
    if (_indicator == nil) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [self.navigationController.view addSubview:_indicator];
        [_indicator aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.centerXY.equalTo(akt_view(self.view));
        }];
        [_indicator setHidesWhenStopped:YES];
    }
    return _indicator;
}

#pragma mark - life cycle
//|---------------------------------------------------------
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
//|---------------------------------------------------------
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航
    self.view.aktName = @"self.view";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithImage:mAKT_Image_Origin(@"P_Back") style:(UIBarButtonItemStylePlain) target:self action:@selector(back)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithImage:mAKT_Image_Origin(@"P_Rotate") style:(UIBarButtonItemStylePlain) target:self action:@selector(rotate)]];
    // 加载Masonry
    [self.indicator startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initUIMas];
        [self.indicator stopAnimating];
    });
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
#pragma mark - click events
//|---------------------------------------------------------
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rotate {
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformRotate(self.view.transform, M_PI/2);
        self.view.frame = CGRectMake(0, 0, self.view.height, self.view.width);
    }];
}

@end
