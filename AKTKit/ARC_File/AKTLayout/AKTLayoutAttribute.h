//
//  AKTLayoutAttribute.h
//  AKTLayout
//
//  Created by YaHaoo on 16/4/15.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

// import-<frameworks.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// import-"models.h"
#import "AKTAttributeItem.h"
// import-"views & controllers.h"

//--------------# Macro #--------------
#define kItemMaximum (10)
//--------------# E.n.d #--------------#>Macro

//--------------------Structs statement, globle variables...--------------------
typedef struct {
    const void *conditionBlock;
    const void *attributeBlock;
} AKTDynamicLayoutBlock;

typedef struct {
    //> 不可变布局信息
    AKTAttributeItem itemArrayForStatic[kItemMaximum];
    int itemCountForStatic;
    //> Layout info, array elements are layout items. 可变布局信息，数组元素是布局项(在满足某种条件时会被重新赋值)
    AKTAttributeItem itemArrayForDynamic[kItemMaximum];
    int itemCountForDynamic;
    
    //> 需要被布局的view
    //> 是否已经检查
    //> 更新布局信息时生成的tag，用以区分不同的布局信息
    //> 是否正在获取动态布局信息, 信息将被存储到动态部分
    //> 有效的布局信息，当某个参照视图销毁时，布局信息将无效
    const void *bindView;
    bool currentLayoutInfoDidCheck;
    long layoutInfoTag;
    bool layoutDynamicContextBegin;
    bool validLayoutAttributeInfo;
    
    AKTDynamicLayoutBlock blockArrayForDynamic[kItemMaximum];
    int blockCountForDynamic;
    
    // 当前参照视图的集合NSMutableSet
    void *currentViewReferenced[kItemMaximum*2];
    int viewReferenced;
} AKTLayoutAttribute;
typedef AKTLayoutAttribute* AKTLayoutAttributeRef;
// Shared attributeRef
extern AKTLayoutAttributeRef attributeRef_global;
//-------------------- E.n.d -------------------->Structs statement, globle variables...
#pragma mark - life cycle
//|---------------------------------------------------------
/**
 *  Initialize AKTLayoutAttribute.
 *  初始化
 *
 *  @param attributeRef "AKTLayoutAttribute" need to be initialized.
 *  @param attributeRef 需要被初始化的"AKTLayoutAttribute"
 *  @param view      The view need to be layout
 *  @param view      需要被布局的视图
 */
void aktLayoutAttributeInit(UIView *view);

#pragma mark - create item
//|---------------------------------------------------------
/**
 *  Create layout attribute item.
 *  创建布局项.
 *
 */
void __akt__create__top();
void __akt__create__left();
void __akt__create__bottom();
void __akt__create__right();
void __akt__create__width();
void __akt__create__height();
void __akt__create__whRatio();
void __akt__create__centerX();
void __akt__create__centerY();
void __akt__create__centerXY();
void __akt__create__edge();
void __akt__create__size();

#pragma mark - function implementations
//|---------------------------------------------------------
/*
 * Calculate layout with the infor from the attribute items, return CGRect
 * Configurations in AKTLayoutParam, as follows configurations can be divided into vertical and horizontal direction
 * In one direction two configurations in addition to "whRatio" is enough to calculate the frame in that direction. WhRation will be convert to the configuration of width or height
 */
CGRect calculateAttribute(AKTLayoutAttributeRef attributeRef, void *referenceViewPtr);

