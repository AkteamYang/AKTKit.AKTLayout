//
//  AKTReferenceObject.h
//  AKTLayout
//
//  Created by YaHaoo on 16/4/15.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
// import-<frameworks.h>
#import <UIKit/UIKit.h>
// import-"models.h"

// import-"views & controllers.h"

//--------------# Macro #--------------
#define akt_value(VALUE) (__akt_value(VALUE))
#define akt_view(VIEW) (__akt_view(VIEW))
#define akt_size(WIDTH, HEIGHT) (__akt_size(WIDTH, HEIGHT))
#define akt_inset(TOP, LEFT, BOTTOM, RIGHT) (__akt_inset(TOP, LEFT, BOTTOM, RIGHT))
//--------------# E.n.d #--------------#>Macro

//--------------------Structs statement, globle variables...--------------------
// AKTAttributeItemType
// 布局项类型
typedef enum {
    AKTAttributeItemType_Top,
    AKTAttributeItemType_Left,
    AKTAttributeItemType_Bottom,
    AKTAttributeItemType_Right,
    AKTAttributeItemType_Width,
    AKTAttributeItemType_Height,
    AKTAttributeItemType_WHRatio,
    AKTAttributeItemType_CenterX,
    AKTAttributeItemType_CenterY,
    AKTAttributeItemType_CenterXY
} AKTAttributeItemType;

// Layout reference type
// 布局参考类型
typedef enum {
    AKTRefenceType_View,
    AKTRefenceType_ViewAttribute,
    AKTRefenceType_Constant
} AKTRefenceType;

typedef struct {
    void *referenceView;
    AKTAttributeItemType type;
}AKTViewAttributeInfo;

typedef struct {
    bool referenceValidate;
    AKTRefenceType referenceType;
    AKTViewAttributeInfo referenceAttribute;
    void *referenceView;
    CGFloat referenceValue;
    CGSize referenceSize;
} AKTReference;
typedef AKTReference* AKTRefenceRef;

/*
 * AKTLayoutReferenceObjInfo
 */
struct AKTReferenceConfigurationStruct {
    AKTReference reference;
    UIEdgeInsets referenceEdgeInsert;
    float referenceMultiple;
    float referenceOffset;
};
typedef struct AKTReferenceConfigurationStruct AKTReferenceConfiguration;
typedef AKTReferenceConfiguration* AKTReferenceConfigurationRef;

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
void aktReferenceConfigurationInit(AKTReferenceConfigurationRef configureRef);

/**
 *  Initialize reference.
 *  参考信息初始化
 *
 *  @param referenceRef Reference need to be initalized.
 *  @param referenceRef 需要被初始化的参考
 */
void aktReferenceInit(AKTRefenceRef referenceRef);
#pragma mark - reference methods
//|---------------------------------------------------------
// Create reference object.
// 创建参考
AKTReference __akt_size(float width, float height);

AKTReference __akt_value(float value);

AKTReference __akt_view(UIView *view);

UIEdgeInsets __akt_inset(float top, float left, float bottom, float right);
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
void __akt__add__multiple(CGFloat value);

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
void __akt__add__offset(CGFloat value);

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
void __akt__add__edgeInset(UIEdgeInsets inset);



