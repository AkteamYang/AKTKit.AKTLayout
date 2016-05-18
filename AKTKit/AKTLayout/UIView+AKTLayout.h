//
//  UIView+QuickLayout.h
//  AKTeamUikitExtension
//
//  Created by YaHaoo on 15/9/8.
//  Copyright (c) 2015年 CoolHear. All rights reserved.
//

#import <UIKit/UIKit.h>
// import-<frameworks.h>
// import-"models.h"
#import "AKTLayoutAttribute.h"
#import "AKTLayoutShell.h"
// import-"views & controllers.h"

//--------------# Macro #--------------
#define AKTLyoutVersion 12
//--------------# E.n.d #--------------#>Macro

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
//-------------------- E.n.d -------------------->Structs statement, globle variables...

/*
 * AktLayout
 */
@interface UIView (AKTLayout)
//> Frame设置相关的属性
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
//> AKTLayout Debug日志将用此名称进行打印日志
@property (copy, nonatomic) NSString *aktName;

- (AKTReference)akt_top;
- (AKTReference)akt_left;
- (AKTReference)akt_bottom;
- (AKTReference)akt_right;
- (AKTReference)akt_width;
- (AKTReference)akt_height;
- (AKTReference)akt_whRatio;
- (AKTReference)akt_centerX;
- (AKTReference)akt_centerY;

#pragma mark - QuickLayout
//|---------------------------------------------------------
/**
 *  快速布局
 *
 *  @param type          快速布局约束类型
 *  @param referenceView 参考视图
 *  @param offset        偏移值
 */
- (void)AKTQuickLayoutWithType:(QuickLayoutConstraintType)type referenceView:(UIView *)referenceView offset:(CGFloat)offset;

#pragma mark - AKTLayout
//|---------------------------------------------------------
/*
 * Configure layout attributes. It's a AKTLayout method and you can add layout items such as: top/left/bottom/width/whRatio... into currentView. When you add items you don't need to care about the order of these items. The syntax is very easy to write and understand. In order to meet the requirements, we did a lot in the internal processing. But the performance is still outstanding. I have already no longer use autolayout. Because autolayout has a bad performance especially when the view is complex.In order to guarantee the performance we can handwrite frame code. But it's a boring thing and a waste of time. What should I do? Please try AKTLayout！！！
 */
- (void)aktLayout:(void(^)(AKTLayoutShellAttribute *layout))layout;
/*
 * The method："aktLayoutUpdate" will be called when the view's frame size changed. We can insert our subview layout code into the method, so that the UI can adaptive change
 * Subview layout code was recommended to insert into the method
 */
- (void)aktLayoutUpdate DEPRECATED_MSG_ATTRIBUTE("Last version 1.1");

/**
 *  从父视图中销毁（我们需要最终销毁视图时调用，从父视图中移除并且删除AKTLayout信息）
 *  提醒：当我们pop、dismiss视图控制器的时候，会自动调用被释放控制器的view的"aktRemoveAKTLayout"，这种情况下无需手动调用。
 */
- (void)aktDestroyFromSuperView;

/**
 *  添加AKTLyout动画
 *
 *  @param animation 动画代码
 */
+ (void)aktAnimation:(void(^)())animation;

/**
 *  是否支持旋转屏幕动画
 *  @备注：当支持旋转屏幕动画时，旋转屏幕视图布局速度将降低！一般情况下默认开启
 *
 *  @param support
 */
+ (void)aktScreenRotatingAnimationSupport:(BOOL)support;
#pragma mark - distribute
//|---------------------------------------------------------
/*
 * 将给定的view分布放置
 * @source：view 数组
 * @rect：最终分布的矩形区域，
 * @lines: 行数
 * @columns: 列数
 * @itemHandler: 每放置好一个view，将会调用一次block
 * @note：view放置在行和列的交叉点
 */
- (void)aktLayoutDistributeSource:(NSArray<UIView *> *)source distributeRect:(CGRect)rect lines:(NSInteger)lines columns:(NSInteger)columns itemHandler:(void(^)(UIView *item))itemHandler;
@end
