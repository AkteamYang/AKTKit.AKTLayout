//
//  AKTReferenceObject.m
//  AKTLayout
//
//  Created by YaHaoo on 16/4/15.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTReferenceConfiguration.h"
// import-<frameworks.h>

// import-"models.h"
#import "AKTLayoutAttribute.h"
// import-"views & controllers.h"

//--------------------Structs statement, globle variables...--------------------
extern AKTLayoutAttributeRef attributeRef_global;
//-------------------- E.n.d -------------------->Structs statement, globle variables...

#pragma mark - life cycle
//|---------------------------------------------------------
/**
 *  Initialize reference configuration.
 *  初始化参考设置.
 *
 *  @param configureRef Reference configuration need to be initalized.
 *  @param configureRef 需要被初始化的参考设置
 */
void aktReferenceConfigurationInit(AKTReferenceConfigurationRef configureRef) {
    aktReferenceInit(&(configureRef->reference));
    configureRef->referenceEdgeInsert        = UIEdgeInsetsMake(FLT_MAX, FLT_MAX, FLT_MAX, FLT_MAX);
    configureRef->referenceMultiple          = 1.f;
    configureRef->referenceOffset            = 0.f;
    configureRef->referenceCoefficientOffset = 0.f;
}

/**
 *  Initialize reference.
 *  参考信息初始化
 *
 *  @param referenceRef Reference need to be initalized.
 *  @param referenceRef 需要被初始化的参考
 */
void aktReferenceInit(AKTRefenceRef referenceRef) {
    referenceRef->referenceValidate   = false;
    referenceRef->referenceAttribute  = (AKTViewAttributeInfo){NULL, 0};
    referenceRef->referenceView       = NULL;
    referenceRef->referenceValue      = FLT_MAX;
    referenceRef->referenceSize       = CGSizeMake(FLT_MAX, FLT_MAX);
}

#pragma mark - reference methods
//|---------------------------------------------------------
AKTReference __akt_size(float width, float height) {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate = true;
    ref.referenceType = AKTRefenceType_Constant;
    ref.referenceSize = (CGSize){width, height};
    return  ref;
}

AKTReference __akt_value(float value) {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate = true;
    ref.referenceType = AKTRefenceType_Constant;
    ref.referenceValue = value;
    return  ref;
}

AKTReference __akt_view(UIView *view) {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate = true;
    ref.referenceType = AKTRefenceType_View;
    ref.referenceView = (__bridge void *)(view);
    return  ref;
}

UIEdgeInsets __akt_inset(float top, float left, float bottom, float right) {
    return (UIEdgeInsets){top, left, bottom, right};
}
#pragma mark - configuration methods
//|---------------------------------------------------------
/**
 *  Transformation of the result.
 *  对于结果的变换
 *
 *  @param value     multiple
 *  @param value     倍数
 *
 */
void __akt__add__multiple(CGFloat value) {
    AKTAttributeItem *itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
    itemRef->configuration.referenceMultiple = value;
    return;
}

/**
 *  Transformation of the result.
 *  对于结果的变换
 *
 *  @param value     Offset
 *  @param value     偏移值
 *
 *  @note The final result ＝ reference object * multiple + offset.
 *  @note 最终的结果＝参考对象＊倍数＋偏移值
 */
void __akt__add__offset(CGFloat value) {
    AKTAttributeItem *itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
    itemRef->configuration.referenceOffset = value;
    return;
}

/**
 *  Transformation of the result.
 *  对于结果的变换
 *
 *  @param value     coefficientOffset
 *  @param value     系数偏移值
 *
 *  @note The final result ＝ (reference object + coefficientOffset)* multiple + offset.
 *  @note 最终的结果＝(参考对象+系数偏移值)＊倍数＋偏移值
 */
void __akt__add__coefficientOffset(CGFloat value) {
    AKTAttributeItem *itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
    itemRef->configuration.referenceCoefficientOffset = value;
    return;
}

/**
 *  The value of edge inset.
 *  边缘插入值
 *
 *  @param inset     Edge inset value
 *  @param inset     插入值
 *
 *  @note Only work when you add the attribute item type "edge" into the layout attribute item. And if this layout attribuite item also add other attribute item types, the other item types will not work.
 *  @note 仅仅对添加了"edge"类型的布局项起作用。同时如果此布局项还添加了其它的布局类型，则其它的布局类型将不起作用。
 */
void __akt__add__edgeInset(UIEdgeInsets inset) {
    AKTAttributeItem *itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
    itemRef->configuration.referenceEdgeInsert = inset;
    return;
}

