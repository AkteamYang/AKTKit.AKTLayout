//
//  AKTAttributeItem.h
//  AKTLayout
//
//  Created by YaHaoo on 16/4/15.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

// import-<frameworks.h>
#import <Foundation/Foundation.h>
// import-"models.h"
#import "AKTReferenceConfiguration.h"
// import-"views & controllers.h"

//--------------# Macro #--------------
#define kTypeMaximum (8)
//--------------# E.n.d #--------------#>Macro

//--------------------Structs statement, globle variables...--------------------
// The definition of "AKTAttributeItem"
// 布局项定义
struct AKTAttributeItemStruct{
    AKTAttributeItemType typeArray[kTypeMaximum];
    int typeCount;
    AKTReferenceConfiguration configuration;
    const void *bindView;
} ;
typedef struct AKTAttributeItemStruct AKTAttributeItem;
typedef AKTAttributeItem* AKTAttributeItemRef;

// View attribute
@interface AKTViewAttribute : NSObject
@property (weak, nonatomic) UIView *referenceView;
@property (assign, nonatomic) AKTAttributeItemType type;
@end
//-------------------- E.n.d -------------------->Structs statement, globle variables...

#pragma mark - life cycle
//|---------------------------------------------------------
/**
 *  Initialize layout attribute item.
 *  布局项初始化
 *
 *  @param itemRef Layout attribute item need to be initalized.
 *  @param itemRef 需要被初始化的布局项
 */
void aktAttributeItemInit(AKTAttributeItemRef itemRef);

#pragma mark - add layout item type methods
//|---------------------------------------------------------
/**
 *  Add layout attribute item type.
 *  添加布局项类型.
 *
 */
void __andTop_imp__();
void __andLeft_imp__();
void __andBottom_imp__();
void __andRight_imp__();
void __andWidth_imp__();
void __andHeight_imp__();
void __andWHRatio_imp__();
void __andCenterX_imp__();
void __andCenterY_imp__();
void __andCenterXY_imp__();

/**
 *  Establish references
 *  建立参照
 *
 *  @param reference Reference layout object：（view，coordinate，size）
 *  @param reference 布局所参考的对象：（视图，坐标，大小）
 *
 *  @return Reference configuration object.
 *  @return 参考设置对象
 */
void __equalTo_imp__(AKTReference reference);
#pragma mark - function implementations
//|---------------------------------------------------------
/**
 *  Get reference value from view attribute.
 *  从veiwAttribute获取参考值
 *
 *  @param attribute View attributes
 *  @param attribute 视图属性
 *  @param bindView  Bind view
 *  @param bindView  绑定视图
 *
 *  @return Reference value
 *  @return 参考值
 */
CGFloat getValue(AKTViewAttributeInfo attributeInfo, UIView *bindView);

/*
 * Return origin*multiple+offset
 */
CGFloat calculate(CGFloat origin, CGFloat multiple, CGFloat coefficientOffset, CGFloat offset);