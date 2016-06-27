//
//  ExampleCoverView.m
//  AKTLayoutExmaple
//
//  Created by HaoYang on 16/6/24.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExampleCoverView.h"
// import-<frameworks.h>
#import "AKTKit.h"
// Function Module

// import-"models.h"

// import-"views..."

// import-"aid.h"

//--------------# Macro & Const #--------------
#define kExampleTint1 mAKT_Color_Color(80, 128, 215, .5)
//--------------# E.n.d #--------------#>Macro

@interface ExampleCoverView()
@property (strong, nonatomic) UIImageView *coverImg;
@property (weak, nonatomic) NSTimer *timer;
@end
@implementation ExampleCoverView
#pragma mark - property settings
- (UIImageView *)coverImg {
    if (!_coverImg) {
        _coverImg = [UIImageView new];
        [self addSubview:_coverImg];
        _coverImg.image = mAKT_Image(@"over.jpg");
        _coverImg.layer.masksToBounds = YES;
    }
    return _coverImg;
}

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - super methods
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.timer) {
        return;
    }
    self.coverImg.transform = CGAffineTransformIdentity;
    self.coverImg.frame = CGRectMake(0, 0, self.width*.96, self.height*.96);
    self.coverImg.center = CGPointMake(self.width/2, self.height/2);
    self.coverImg.layer.cornerRadius = self.coverImg.width/2;
    self.layer.cornerRadius = self.width/2;
}

#pragma mark - view settings
- (void)initUI {
    self.layer.masksToBounds = YES;
    self.backgroundColor = kExampleTint1;
    _coverImg = self.coverImg;
}

#pragma mark - click events
- (void)timer:(NSTimer *)timer {
    self.coverImg.transform = CGAffineTransformRotate(self.coverImg.transform, (M_PI/(1000)));
}

#pragma mark - function implementations
/**
 *  Set cover image rotate or not.
 *
 *  @param rotate
 */
- (void)rotate:(BOOL)rotate {
    if (rotate) {
        if (!self.timer) {
            NSInvocation *invocation = [[NSInvocation alloc]init];
            [invocation setTarget:self];
            [invocation setSelector:@selector(timer:)];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        }
    }else{
        [self.timer invalidate];
    }
}
@end
