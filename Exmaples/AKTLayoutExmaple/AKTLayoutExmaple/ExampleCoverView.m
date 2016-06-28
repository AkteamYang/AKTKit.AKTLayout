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
@end
@implementation ExampleCoverView
#pragma mark - property settings
- (UIImageView *)coverImg {
    if (!_coverImg) {
        _coverImg = [UIImageView new];
        [self addSubview:_coverImg];
        _coverImg.image = mAKT_Image(@"over.jpg");
        _coverImg.layer.masksToBounds = YES;
        [_coverImg aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.edge.equalTo(akt_view(self));
        }];
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

#pragma mark - view settings
- (void)initUI {
    self.layer.masksToBounds = YES;
    self.backgroundColor = kExampleTint1;
    _coverImg = self.coverImg;
}
@end
