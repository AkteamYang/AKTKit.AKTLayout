//
//  UIView+QuickLayout.h
//  AKTeamUikitExtension
//
//  Our goal is to be the best framework for automatic layout
//  Your support will help AKTLayout rising, welcome to provide code support, suggest improvements   to AKTLayout or lit a Star for us
//  https://github.com/AkteamYang/AKTKit.AKTLayout
//  AKTLayout version 1.2.0
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
 * 添加AKTLayout布局属性，你可以为视图添加多种布局项（top/left/bottom/width/whRatio...），当你添加布局项时你不用关心添加的顺序，语法非常容易理解和编写，为了达到要求我们进行了很多内部转换，但是仍然保持了高性能表现，我已经很久不用系统的自动布局，因为在复杂的视图关系中，它的性能表现实在过于糟糕，为了达到性能要求，必须要手写并计算布局代码，这是一件令人乏味而耗费时间的事情，如果你正在被这些问题困扰，可以尝试一下性能优异的AKTLayout！！！
 *   https://github.com/AkteamYang/AKTKit.AKTLayout
 *   我们的目标是成为最好的自动布局框架
 *   你的支持将有助于AKTLayout不断提升，欢迎为AKTLayout提供代码支持、改进建议或者为我们点上一颗Star
 */
- (void)aktLayout:(void(^)(AKTLayoutShellAttribute *layout))layout;

/**
 *  设置视图需要刷新布局
 *  @备注：一般在更改了view的size需要立刻执行布局刷新时调用
 */
- (void)setAKTNeedRelayout;

/**
 *  已经完成布局
 *  @备注：当视图布局完成时会回调这个方法
 *
 *  @param target
 *  @param selector  selector的参数是当前的view (- (void)viewDidLayout:(UIView *)view)
 */
- (void)aktDidLayoutTarget:(id)target forSelector:(SEL)selector;

/**
 *  已经完成布局
 *
 *  @param complete
 */
- (void)aktDidLayoutWithComplete:(void(^)(UIView *view))complete;

/*
 * 当view的size变化时将被自动调用
 * 在1.0以上版本中已被废弃，不建议再使用，如果要使用请重写"layoutSubviews"方法。
 */
- (void)aktLayoutUpdate DEPRECATED_MSG_ATTRIBUTE("Last version 1.0");

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
