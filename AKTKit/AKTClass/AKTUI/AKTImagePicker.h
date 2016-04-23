//
//  AKTImagePicker.h
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/11.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AKTImagePicker : NSObject
//> Call this block when finished.
//> 操作完成时回调此block
@property (strong, nonatomic) void(^result)(BOOL cancled, UIImage *img);
@property (assign, nonatomic) BOOL enableEditing;
@property (assign, nonatomic) CGSize size;
- (void)chooseFromLibrary;
- (void)chooseFromCamera;
@end
