//
//  UIView+ViewAttribute.h
//  AKTLayout
//
//  Created by YaHaoo on 16/4/16.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>
//--------------------Structs statement, globle variables...--------------------
// QuickLayoutConstraintType
typedef NS_ENUM(NSInteger, QuickLayoutConstraintType) {
    QuickLayoutConstraintAlignTo_Top,
    QuickLayoutConstraintAlignTo_Left,
    QuickLayoutConstraintAlignTo_Bottom,
    QuickLayoutConstraintAlignTo_Right,
    
    QuickLayoutConstraintSpaceTo_Top,
    QuickLayoutConstraintSpaceTo_Left,
    QuickLayoutConstraintSpaceTo_Bottom,
    QuickLayoutConstraintSpaceTo_Right,
    
    QuickLayoutConstraintAlign_Vertical,
    QuickLayoutConstraintAlign_Horizontal,
    
    QuickLayoutConstraintWidth,
    QuickLayoutConstraintHeight,
    QuickLayoutConstraintRateW_H
};
struct AKTTestStruct {
    struct AKTTestStruct (*equalToConstant)(float constant);
};
typedef struct AKTTestStruct AKTTest;
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface UIView (ViewAttribute)
///< Properties related to frame
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
///< The width or height will be adaptive if we set the corresponding value to YES. But if all of the two values were setted to YES or NO the view wouldn't be adaptive.
@property (strong, nonatomic) NSNumber *adaptiveWidth;
@property (strong, nonatomic) NSNumber *adaptiveHeight;
@property (copy, nonatomic) NSString *aktName;
@property (assign, nonatomic) void *attributeRef;
//> Layout chain, including layout which referenced to the current view, when the current view layout change will refresh-related layout.
//> 布局链, 包含了参考了当前视图的布局，当当前视图布局改变时将刷新相关的布局。
@property (readonly, strong, nonatomic) NSMutableArray *layoutChain;
//> The views which were referened by currrent view.
//> 当前视图所参考的视图
@property (readonly, strong, nonatomic) NSMutableArray *viewsReferenced;
//> The number of node views which are not setting layout
//> 子节点不在进行布局运算的视图的数量
//@property (assign, nonatomic) NSInteger layoutCount;
//> It's active by default.
//> 默认是激活状态，允许布局操作，
@property (assign, nonatomic) BOOL layoutActive;
//> All layout operation complete, before view enter active mode we should run over blocks in the array. 
//> 所有布局操作完成，view即将再次进入激活模式前，需要完成的操作
@property (readonly, strong, nonatomic) NSMutableArray *layoutComplete;

/*
 *  Layout
 *
 *  @param type          layout type
 *  @param referenceView reference view
 *  @param offset        offset
 */
- (void)AKTQuickLayoutWithType:(QuickLayoutConstraintType)type referenceView:(UIView *)referenceView offset:(CGFloat)offset;
@end
