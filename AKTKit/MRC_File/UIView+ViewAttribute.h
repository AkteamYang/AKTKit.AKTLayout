//
//  UIView+ViewAttribute.h
//  AKTLayout
//
//  Created by YaHaoo on 16/4/16.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AKTWeakContainer;

/**
 *  AKTLayout的布局更新处理模块MRC编译选项
 */
@interface UIView (ViewAttribute)
//> 自适应高度和宽度，默认值为nil，不做任何自适应处理
@property (strong, nonatomic) NSNumber *adaptiveWidth;
@property (strong, nonatomic) NSNumber *adaptiveHeight;
//> 布局信息
@property (assign, nonatomic) void *attributeRef;
//> 布局链, 包含了参考了当前视图的布局，当当前视图布局改变时将刷新链表中的视图的布局
@property (readonly, strong, nonatomic) NSMutableSet<AKTWeakContainer *> *layoutChain;
//> 当前视图所参考的视图的数组
@property (readonly, strong, nonatomic) NSMutableSet<AKTWeakContainer *> *viewsReferenced;
//> 布局需要被刷新次数
@property (assign, nonatomic) NSInteger layoutUpdateCount;
//> 弱引用容器
@property (retain, nonatomic) AKTWeakContainer *aktContainer;

/**
 *  AKTLayout standard log
 *
 *  @param errorCode
 *  @param description
 *  @param suggest
 */
void __aktErrorReporter(int errorCode, NSString *description, NSString *suggest);

/**
 *  已经布局完成回调
 *
 *  @param view 当前视图
 */
void __aktViewDidLayoutWithView(UIView *view);
@end

@interface AKTWeakContainer : NSObject
@property (assign, nonatomic) UIView *weakView;
@end
