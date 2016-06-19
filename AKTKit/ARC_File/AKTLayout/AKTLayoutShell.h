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
/*
 * Multiple and offset
 */
- (AKTLayoutShellConfigure *(^)(CGFloat obj))multiple;
- (AKTLayoutShellConfigure *(^)(CGFloat obj))offset;
- (AKTLayoutShellConfigure *(^)(CGFloat obj))coefficientOffset;
- (AKTLayoutShellConfigure *(^)(UIEdgeInsets inset))edgeInset;
@end

@interface AKTLayoutShellItem : NSObject
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
AKTLayoutShellAttribute *sharedShellAttribute();
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

/**
 *  Add dynamic layout for view. Layout info will be update when needed.
 *  @note: When the condition returned YES, attribute will be update to the view's layout info storage.
 *
 *  @param condition Condition for updating layout info.
 *  @param attribute Block for updateing layout info.
 */
- (void)addDynamicLayoutInCondition:(BOOL(^)())condition andAttribute:(void(^)(AKTLayoutShellAttribute *dynamicLayout))attribute;
@end
