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
    self.coverImg.frame = CGRectMake(0, 0, self.width-16, self.height-16);
    self.coverImg.center = CGPointMake(self.width/2, self.height/2);
    self.coverImg.layer.cornerRadius = self.coverImg.width/2;
    self.layer.cornerRadius = self.width/2;
}

#pragma mark - view settings
- (void)initUI {
    self.layer.masksToBounds = YES;
    self.backgroundColor = mAKT_Color_Background_230;
    _coverImg = self.coverImg;
}

#pragma mark - click events
- (void)timer:(NSTimer *)timer {
    self.coverImg.transform = CGAffineTransformRotate(self.coverImg.transform, (M_PI/(1800)));
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
