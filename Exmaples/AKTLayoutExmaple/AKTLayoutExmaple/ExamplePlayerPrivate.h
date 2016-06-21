//
//  ExamplePlayerPrivate.h
//  AKTLayoutExmaple
//
//  Created by HaoYang on 16/6/21.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExamplePlayerPrivate <NSObject>
@optional
@property (strong, nonatomic) UILabel *drag;
@property (strong, nonatomic) UIView *container;

// Player UI controls
@property (strong, nonatomic) UIImageView *coverLittle;
@property (strong, nonatomic) UILabel *musicName;
@property (strong, nonatomic) UILabel *artist;
@property (strong, nonatomic) UIButton *play;
@property (strong, nonatomic) UIButton *list;
@property (strong, nonatomic) UIButton *nextMusic;
@property (strong, nonatomic) UIButton *lastMusic;
@end
