//
//  AKTLayoutShellAttribute.h
//  Test
//
//  Created by YaHaoo on 16/4/19.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
// import-<frameworks.h>

// import-"models.h"
#import "UIView+ViewAttribute.h"
#import "AKTLayoutAttribute.h"
// import-"views & controllers.h"


@interface AKTLayoutShellConfigure : NSObject
+ (AKTLayoutShellConfigure *)sharedInstance;

/*
 * Multiple and offset
 */
- (AKTLayoutShellConfigure *(^)(CGFloat obj))multiple;
- (AKTLayoutShellConfigure *(^)(CGFloat obj))offset;
- (AKTLayoutShellConfigure *(^)(UIEdgeInsets inset))edgeInset;
@end

@interface AKTLayoutShellItem : NSObject
+ (AKTLayoutShellItem *)sharedInstance;

// Configure layout attribute item
- (AKTLayoutShellItem *)top;
- (AKTLayoutShellItem *)left;
- (AKTLayoutShellItem *)bottom;
- (AKTLayoutShellItem *)right;
- (AKTLayoutShellItem *)width;
- (AKTLayoutShellItem *)height;
- (AKTLayoutShellItem *)whRatio;
- (AKTLayoutShellItem *)centerX;
- (AKTLayoutShellItem *)centerY;
- (AKTLayoutShellItem *)centerXY;

// End set layout attribute item and set reference object
- (AKTLayoutShellConfigure *(^)(AKTReference reference))equalTo;
@end

@interface AKTLayoutShellAttribute : NSObject
+ (AKTLayoutShellAttribute *)sharedInstance;
/*
 * Create layout attribute item
 */
- (AKTLayoutShellItem *)top;
- (AKTLayoutShellItem *)left;
- (AKTLayoutShellItem *)bottom;
- (AKTLayoutShellItem *)right;
- (AKTLayoutShellItem *)width;
- (AKTLayoutShellItem *)height;
- (AKTLayoutShellItem *)whRatio;
- (AKTLayoutShellItem *)centerX;
- (AKTLayoutShellItem *)centerY;
- (AKTLayoutShellItem *)centerXY;
- (AKTLayoutShellItem *)edge;
- (AKTLayoutShellItem *)size;
@end
