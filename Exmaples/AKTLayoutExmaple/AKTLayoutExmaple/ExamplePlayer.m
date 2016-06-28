//
//  ExamplePlayer.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/5/25.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExamplePlayer.h"
#import "AKTKit.h"
// import-<frameworks.h>

// Function Module
#import "ExamplePlayer+UIControls.h"
#import "ExamplePlayerPrivate.h"
// import-"models.h"

// import-"views..."

// import-"aid.h"

@interface ExamplePlayer ()<ExamplePlayerPrivate>

@end
@implementation ExamplePlayer
@synthesize drag = _drag;
@synthesize container = _container;
@synthesize coverLittle;
@synthesize musicName;
@synthesize artist;
@synthesize list;
@synthesize mode;
@synthesize play;
@synthesize nextMusic;
@synthesize lastMusic;
@synthesize slider;
@synthesize currentTime;
@synthesize duration;
@synthesize cover;
@synthesize topMusicName;
@synthesize topArtist;

#pragma mark - property settings
- (UILabel *)drag {
    if (_drag == nil) {
        _drag = [UILabel new];
        [self.view addSubview:_drag];
        _drag.y = 200;
        // 动态布局内部参照的视图需要声明为弱引用再使用。
        // 静态布局不必声明弱引用变量，因为静态布局的block执行完之后就被释放，不会长期持有。
        AKTWeakView(__self, self);
        AKTWeakView(__drag, _drag);
        [_drag aktLayout:^(AKTLayoutShellAttribute *layout) {
            // 静态布局（一直存在的布局关系）
            layout.centerX.left.equalTo(akt_view(self.view));
            // 动态布局（在不同条件下会发生变化的布局关系）
            [layout addDynamicLayoutInCondition:^BOOL{
                return (__drag.y<64+1);
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.top.equalTo(__self.navigationController.navigationBar.akt_bottom);
                dynamicLayout.height.equalTo(akt_value(40));
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return (__drag.y>=64+1);
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.bottom.equalTo(__self.view.akt_bottom).offset(-55);
                dynamicLayout.height.equalTo(akt_value(40));
            }];
        }];
        _drag.text = @"Drag the slider";
        [_drag setTextAlignment:(NSTextAlignmentCenter)];
        _drag.backgroundColor = mAKT_Color_Background_230;
        _drag.textColor = mAKT_Color_Text_102;
        _drag.font = mAKT_Font_12;
        [_drag setNumberOfLines:3];
        _drag.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_drag addGestureRecognizer:tap];
        [_drag addGestureRecognizer:pan];
        _drag.aktName = @"_drag";
    }
    return _drag;
}

- (UIView *)container {
    if (_container == nil) {
        _container = [UIView new];
        [self.view addSubview:_container];
        AKTWeakView(__drag, self.drag);
        AKTWeakView(__self, self);
        [_container aktLayout:^(AKTLayoutShellAttribute *layout) {
            [layout addDynamicLayoutInCondition:^BOOL{
                return YES;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.top.equalTo(__drag.akt_bottom);
                dynamicLayout.left.bottom.right.equalTo(akt_view(__self.view));
            }];
        }];
        [_container setBackgroundColor:mAKT_Color_White];
        [_container setClipsToBounds:YES];
        _container.aktName = @"_container";
    }
    return _container;
}

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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:mAKT_Color_White,NSFontAttributeName:mAKT_Font_18}];
    self.view.aktName = @"self.view";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithImage:mAKT_Image_Origin(@"P_Back") style:(UIBarButtonItemStylePlain) target:self action:@selector(back)]];
    // UI控件
    _drag = self.drag;
    _container = self.container;
    [self initUIForContainer];
}

- (void)show {
    [UIView aktAnimation:^{
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:.1 options:0 animations:^{
            self.drag.y = 64;
        } completion:^(BOOL finished) {

        }];
    }];
}

- (void)hide {
    [UIView aktAnimation:^{
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:.1 options:0 animations:^{
            self.drag.y = self.view.height-self.drag.height-55;
        } completion:^(BOOL finished) {
           
        }];
    }];
}

#pragma mark - click events
- (void)back {
    [UIView aktScreenRotatingAnimationSupport:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    UIView *view = pan.view;
    static CGRect startRect;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startRect = view.frame;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        CGFloat y = point.y+startRect.origin.y;
        CGFloat statusBar = [UIApplication sharedApplication].statusBarHidden? 0:20;
        if (y>=self.view.height-view.height){
            view.y = self.view.height-view.height;
        }else if (y<self.view.height-view.height && y>(self.navigationController.navigationBar.height+statusBar)) {
            view.y = y;
        }else if (y<=(self.navigationController.navigationBar.height+statusBar)){
            view.y = (self.navigationController.navigationBar.height+statusBar);
        }
    }else{
        if (startRect.origin.y-view.frame.origin.y<60) {
            [self hide];
        }else{
            [self show];
        }
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (self.drag.y<64+1) {
        [self hide];
    }else{
        [self show];
    }
}
@end
