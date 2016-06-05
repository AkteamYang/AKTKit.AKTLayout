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
            layout.centerX.left.equalTo(akt_view(self.view));
            layout.height.equalTo(akt_value(60));
            layout.top.equalTo(self.navigationController.navigationBar.akt_bottom);
        }];
        _drag.text = @"Drag the slider";
        [_drag setTextAlignment:(NSTextAlignmentCenter)];
        _drag.backgroundColor = mAKT_Color_Background_204;
        _drag.textColor = mAKT_Color_Text_255;
        [_drag setNumberOfLines:3];
        _drag.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [_drag addGestureRecognizer:pan];
    }
    return _drag;
}

- (UIView *)container {
    if (_container == nil) {
        _container = [UIView new];
        [self.view addSubview:_container];
        [_container aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.top.equalTo(self.drag.akt_bottom);
            layout.left.bottom.right.equalTo(akt_view(self.view));
        }];
        [_container setBackgroundColor:mAKT_Color_Text_52];
    }
    return _container;
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
    _container = self.container;
}

#pragma mark - click events
//|---------------------------------------------------------
- (void)back {
    [UIView aktScreenRotatingAnimationSupport:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    UIView *view = pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        [view aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.left.right.equalTo(akt_view(self.view));
        }];
    }else{
        CGFloat y = point.y+view.y;
        CGFloat statusBar = [UIApplication sharedApplication].statusBarHidden? 0:20;
        if (y>=self.view.height-view.height){
            view.y = self.view.height-view.height;
        }else if (y<self.view.height-view.height && y>(self.navigationController.navigationBar.height+statusBar)) {
            view.y = y;
        }else if (y<=(self.navigationController.navigationBar.height+statusBar)){
            view.y = (self.navigationController.navigationBar.height+statusBar);
        }
    }
    [pan setTranslation:CGPointZero inView:self.view];
}
@end
