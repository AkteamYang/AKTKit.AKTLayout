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
#import "UIView+ViewAttribute.h"
#import "AKTLayoutAttribute.h"
#import "AKTLayoutShell.h"
// import-"views & controllers.h"

/*
 * AktLayout
 */
@interface UIView (AKTLayout)
- (AKTRefence)akt_top;
- (AKTRefence)akt_left;
- (AKTRefence)akt_bottom;
- (AKTRefence)akt_right;
- (AKTRefence)akt_width;
- (AKTRefence)akt_height;
- (AKTRefence)akt_whRatio;
- (AKTRefence)akt_centerX;
- (AKTRefence)akt_centerY;

/*
 * Configure layout attributes. It's a AKTLayout method and you can add layout items such as: top/left/bottom/width/whRatio... into currentView. When you add items you don't need to care about the order of these items. The syntax is very easy to write and understand. In order to meet the requirements, we did a lot in the internal processing. But the performance is still outstanding. I have already no longer use autolayout. Because autolayout has a bad performance especially when the view is complex.In order to guarantee the performance we can handwrite frame code. But it's a boring thing and a waste of time. What should I do? Please try AKTLayout！！！
 */
- (void)aktLayout:(void(^)(AKTLayoutShellAttribute *layout))layout;
/*
 * The method："aktLayoutUpdate" will be called when the view's frame size changed. We can insert our subview layout code into the method, so that the UI can adaptive change
 * Subview layout code was recommended to insert into the method
 */
- (void)aktLayoutUpdate;

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
