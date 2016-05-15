//
//  UIView+ViewAttribute.h
//  AKTLayout
//
//  Created by YaHaoo on 16/4/16.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>

//--------------------Structs statement, globle variables...--------------------
// 快速布局约束类型
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
//> Frame设置相关的属性
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
//> 自适应高度和宽度，默认值为nil，不做任何自适应处理
@property (strong, nonatomic) NSNumber *adaptiveWidth;
@property (strong, nonatomic) NSNumber *adaptiveHeight;
//> AKTLayout Debug日志将用此名称进行打印日志
@property (copy, nonatomic) NSString *aktName;
//> 布局信息
@property (assign, nonatomic) void *attributeRef;
//> 布局链, 包含了参考了当前视图的布局，当当前视图布局改变时将刷新链表中的视图的布局
@property (readonly, strong, nonatomic) NSMutableArray *layoutChain;
//> 当前视图所参考的视图的数组
@property (readonly, strong, nonatomic) NSMutableArray *viewsReferenced;
//> 布局需要被刷新次数
@property (assign, nonatomic) NSInteger layoutUpdateCount;

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
