//
//  ExamplePlayer.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/5/25.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExamplePlayer.h"
#import "AKTKit.h"

@interface ExamplePlayer ()
@property (strong, nonatomic) UILabel *drag;
@property (strong, nonatomic) UIView *container;
@end

@implementation ExamplePlayer
#pragma mark - property settings
//|---------------------------------------------------------
- (UILabel *)drag {
    if (_drag == nil) {
        _drag = [UILabel new];
        [self.view addSubview:_drag];
        [_drag aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.centerX.equalTo(akt_view(self.view));
            layout.top.equalTo(self.navigationController.navigationBar.akt_bottom);
        }];
        _drag.y = self.navigationController.navigationBar.height;
        _drag.text = @"未完待续....";
        [_drag setTextAlignment:(NSTextAlignmentCenter)];
        _drag.backgroundColor = mAKT_Color_Background_204;
        _drag.textColor = mAKT_Color_Text_255;
    }
    return _drag;
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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:mAKT_Color_White,NSFontAttributeName:mAKT_Font_18}];
    self.view.aktName = @"self.view";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithImage:mAKT_Image_Origin(@"P_Back") style:(UIBarButtonItemStylePlain) target:self action:@selector(back)]];
    // UI控件
    _drag = self.drag;
}

#pragma mark - click events
//|---------------------------------------------------------
- (void)back {
    [UIView aktScreenRotatingAnimationSupport:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
