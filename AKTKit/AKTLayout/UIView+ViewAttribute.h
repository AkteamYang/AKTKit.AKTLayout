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
///< Frame设置相关的属性
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

/**
 *  快速布局
 *
 *  @param type          快速布局约束类型
 *  @param referenceView 参考视图
 *  @param offset        偏移值
 */
- (void)AKTQuickLayoutWithType:(QuickLayoutConstraintType)type referenceView:(UIView *)referenceView offset:(CGFloat)offset;

/**
 *  从父视图中销毁（我们需要最终销毁视图时调用，从父视图中移除并且删除AKTLayout信息）
 *  提醒：当我们pop、dismiss视图控制器的时候，会自动调用被释放控制器的view的"aktRemoveAKTLayout"，这种情况下无需手动调用。
 */
- (void)aktDestroyFromSuperView;
@end
