//
//  ExamplePlayerPrivate.h
//  AKTLayoutExmaple
//
//  Created by HaoYang on 16/6/21.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExampleCoverView.h"

@protocol ExamplePlayerPrivate <NSObject>
@optional
@property (strong, nonatomic) UILabel *drag;
@property (strong, nonatomic) UIView *container;

// Player UI controls
@property (strong, nonatomic) UIImageView *coverLittle;
@property (strong, nonatomic) UILabel *musicName;
@property (strong, nonatomic) UILabel *artist;
//> Player music control
@property (strong, nonatomic) UIButton *play;
@property (strong, nonatomic) UIButton *nextMusic;
@property (strong, nonatomic) UIButton *lastMusic;
@property (strong, nonatomic) UIButton *list;
@property (strong, nonatomic) UIButton *mode;
//> Player progress control
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UILabel *currentTime;
@property (strong, nonatomic) UILabel *duration;
//> Big cover
@property (strong, nonatomic) ExampleCoverView *cover;
//> Music and artist label on the top
@property (strong, nonatomic) UILabel *topMusicName;
@property (strong, nonatomic) UILabel *topArtist;
@end
