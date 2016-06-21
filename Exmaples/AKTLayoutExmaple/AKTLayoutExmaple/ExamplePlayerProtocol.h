//
//  ExamplePlayerProtocol.h
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/6/21.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExamplePlayerProtocol <NSObject>
@property (strong, nonatomic) UILabel *drag;
@property (strong, nonatomic) UIView *container;

// Player UI controls
@property (strong, nonatomic) UIImageView *coverLittle;
@end