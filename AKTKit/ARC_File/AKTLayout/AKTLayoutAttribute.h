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
    //> 不可变布局信息
    AKTAttributeItem itemArrayForStatic[kItemMaximum];
    int itemCountForStatic;
    //> Layout info, array elements are layout items. 可变布局信息，数组元素是布局项(在满足某种条件时会被重新赋值)
    AKTAttributeItem itemArrayForDynamic[kItemMaximum];
    int itemCountForDynamic;
    //> 需要被布局的view
    const void *bindView;
    //> 是否已经检查
    bool check;
    //> 更新布局信息时生成的tag，用以区分不同的布局信息
    long layoutInfoTag;
    //> 获取布局信息（void(^)(AKTLayoutShellAttribute *layout, AKTLayoutShellContext context)）
    const void *layoutInfoFetchBlock;
    //> 是否正在更新布局信息
    bool layoutDynamicContextBegin;
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
bool __akt__create__top();
bool __akt__create__left();
bool __akt__create__bottom();
bool __akt__create__right();
bool __akt__create__width();
bool __akt__create__height();
bool __akt__create__whRatio();
bool __akt__create__centerX();
bool __akt__create__centerY();
bool __akt__create__centerXY();
bool __akt__create__edge();
bool __akt__create__size();

#pragma mark - function implementations
//|---------------------------------------------------------
/*
 * Calculate layout with the infor from the attribute items, return CGRect
 * Configurations in AKTLayoutParam, as follows configurations can be divided into vertical and horizontal direction
 * In one direction two configurations in addition to "whRatio" is enough to calculate the frame in that direction. WhRation will be convert to the configuration of width or height
  */
CGRect calculateAttribute(AKTLayoutAttributeRef attributeRef);

