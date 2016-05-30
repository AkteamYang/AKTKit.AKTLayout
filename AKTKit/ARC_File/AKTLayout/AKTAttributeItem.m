//
//  AKTAttributeItem.c
//  AKTLayout
//
//  Created by YaHaoo on 16/4/15.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTAttributeItem.h"
// import-<frameworks.h>

// import-"models.h"
#import "UIView+AKTLayout.h"
#import "AKTPublic.h"
#import "AKTLayoutAttribute.h"
// import-"views & controllers.h"


//--------------------Structs statement, globle variables...--------------------
/**
 *  Add item type into layout attribute item.
 *
 *  @param type    Attribute item type.
 *
 */
bool addItemType(AKTAttributeItemType type);
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
void aktAttributeItemInit(AKTAttributeItemRef itemRef) {
    itemRef->typeCount = 0;
    itemRef->bindView  = NULL;
    // Initialize reference configuration.
    // 初始化参考配置
    aktReferenceConfigurationInit(&(itemRef->configuration));
}

#pragma mark - add layout item type methods
//|---------------------------------------------------------
/**
 *  Add layout attribute item type.
 *  添加布局项类型.
 *
 *  @return layout attribute item added type.
 *  @return 已添加类型的布局项.
 */
bool __andTop_imp__() {
    return addItemType(AKTAttributeItemType_Top);
}

bool __andLeft_imp__() {
    return addItemType(AKTAttributeItemType_Left);
}

bool __andBottom_imp__() {
    return addItemType(AKTAttributeItemType_Bottom);
}

bool __andRight_imp__() {
    return addItemType(AKTAttributeItemType_Right);
}

bool __andWidth_imp__() {
    return addItemType(AKTAttributeItemType_Width);
}

bool __andHeight_imp__() {
    return addItemType(AKTAttributeItemType_Height);
}

bool __andWHRatio_imp__() {
    return addItemType(AKTAttributeItemType_WHRatio);
}

bool __andCenterX_imp__() {
    return addItemType(AKTAttributeItemType_CenterX);
}

bool __andCenterY_imp__() {
    return addItemType(AKTAttributeItemType_CenterY);
}

bool __andCenterXY_imp__() {
    return addItemType(AKTAttributeItemType_CenterXY);
}

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
bool __equalTo_imp__(AKTReference reference) {
    AKTAttributeItemRef itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
    if (!reference.referenceValidate) {
        UIView *bindView = (__bridge UIView *)(itemRef->bindView);
        mAKT_Log(@"%@: %@\nRefefence invalide!",[bindView class], bindView.aktName);
        return false;
    }
    // If added edgeinset item type, and reference types are: "NSNumber", "NSVale", "AKT ViewAttribute", the reference set is invalid.
    // 如果设置了edgeinset，并且参考类型是："NSNumber", "NSValue", "AKTViewAttribute",则参照设置是无效的
    BOOL (^edgeCheck)() = ^(){
        if (itemRef->configuration.referenceEdgeInsert.top<(FLT_MAX-1)) {
            UIView *bindView = (__bridge UIView *)(itemRef->bindView);
            mAKT_Log(@"%@: %@\n// 对于edge设置参考Constant或者ViewAttribute是没有意义的", [bindView class],bindView.aktName);
            return YES;
        }
        return NO;
    };
    // If added size item type, and reference types are: "NSNumber", "AKT ViewAttribute", the reference set is invalid.
    // 如果设置了size，并且参考类型是："NSNumber", "AKTViewAttribute",则参照设置是无效的
    BOOL (^sizeCheck)() = ^(){
        if (itemRef->configuration.reference.referenceSize.width<(FLT_MAX-1)) {
            UIView *bindView = (__bridge UIView *)(itemRef->bindView);
            mAKT_Log(@"%@: %@\n// 对于size设置参考Constant或者ViewAttribute是没有意义的", [bindView class],bindView.aktName);
            return YES;
        }
        return NO;
    };

    switch (reference.referenceType) {
        case AKTRefenceType_View:
            // Add reference view
            if(itemRef->configuration.reference.referenceSize.width<FLT_MAX-1) reference.referenceSize = itemRef->configuration.reference.referenceSize;
            itemRef->configuration.reference = reference;
            return true;
            break;
        case AKTRefenceType_Constant:// value and size
        {
            // If added edgeinset reference type, these references setted are invalid. You must reference to a view.
            // 如果设置了edgeinset参考类型，则设置这些参考是无效的，必须设置一个view为参照
            if (edgeCheck()) {
                return false;
            }
            // 布局项有size类型
            if (itemRef->configuration.reference.referenceSize.width<FLT_MAX-1) {
                // 设置非size参考
                if (reference.referenceValue<FLT_MAX-1) {
                    UIView *bindView = (__bridge UIView *)(itemRef->bindView);
                    mAKT_Log(@"%@: %@\n// 对于size设置参考固定值和ViewAttribute是没有意义的", [bindView class],bindView.aktName);
                    return false;
                }
            }else{
                // 设置size参考
                if (reference.referenceSize.width<FLT_MAX-1) {
                    UIView *bindView = (__bridge UIView *)(itemRef->bindView);
                    mAKT_Log(@"%@: %@\n// 对于位置：top、left、bottom...设置参考size是没有意义的", [bindView class],bindView.aktName);
                    return false;
                }
            }
            // Add reference constant
            itemRef->configuration.reference = reference;
            return true;
        }
            break;
        case AKTRefenceType_ViewAttribute:
            // If added edgeinset and size constraints, these references setted are invalid. You must reference to a view.
            // 如果设置了edgeinset和size约束，则设置这些参考是无效的，必须设置一个view为参照
            if (edgeCheck() || sizeCheck()) {
                return false;
            }
            itemRef->configuration.reference = reference;
            return true;
            break;
        default:
            break;
    }
}

/**
 *  Add item type into layout attribute item.
 *
 *  @param itemRef Layout attribute item.
 *  @param type    Attribute item type.
 *
 */
bool addItemType(AKTAttributeItemType type) {
    AKTAttributeItemRef itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
    // Check whether out of range
    if (itemRef->typeCount==kTypeMaximum) {
        UIView *bindView = (__bridge UIView *)itemRef->bindView;
        mAKT_Log(@"%@: %@\nOut of the range of attributeItemType array",[bindView class], bindView.aktName);
        return false;
    }
    // Add itemType to itemInfo
    itemRef->typeArray[itemRef->typeCount] = type;
    itemRef->typeCount++;
    return true;
}

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
CGFloat getValue(AKTViewAttributeInfo attributeInfo, UIView *bindView){
    UIView *v = (__bridge UIView *)(attributeInfo.referenceView);
    CGRect viewRec = [bindView.superview convertRect:v.frame fromView:v.superview? v.superview:mAKT_APPDELEGATE.keyWindow];
    CGFloat result= 0.0f;
    switch (attributeInfo.type) {
        case AKTAttributeItemType_Top:
        {
            result = viewRec.origin.y;
            break;
        }
        case AKTAttributeItemType_Left:
        {
            result = viewRec.origin.x;
            break;
        }
        case AKTAttributeItemType_Bottom:
        {
            result = viewRec.origin.y+viewRec.size.height;
            break;
        }
        case AKTAttributeItemType_Right:
        {
            result = viewRec.origin.x+viewRec.size.width;
            break;
        }
        case AKTAttributeItemType_Width:
        {
            result = viewRec.size.width;
            break;
        }
        case AKTAttributeItemType_Height:
        {
            result = viewRec.size.height;
            break;
        }
        case AKTAttributeItemType_CenterX:
        {
            result = viewRec.origin.x+viewRec.size.width/2;
            break;
        }
        case AKTAttributeItemType_CenterY:
        {
            result = viewRec.origin.y+viewRec.size.height/2;
            break;
        }
        default:
            break;
    }
    return result;
}

/*
 * Return origin*multiple+offset
 */
CGFloat calculate(CGFloat origin, CGFloat multiple, CGFloat offset) {
    return origin*multiple+offset;
}
//---------------------------------------------------------
@implementation AKTViewAttribute
@end
