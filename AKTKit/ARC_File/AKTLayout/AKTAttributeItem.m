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
void addItemType(AKTAttributeItemType type);
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
void __andTop_imp__() {
    addItemType(AKTAttributeItemType_Top);
}

void __andLeft_imp__() {
    addItemType(AKTAttributeItemType_Left);
}

void __andBottom_imp__() {
    addItemType(AKTAttributeItemType_Bottom);
}

void __andRight_imp__() {
    addItemType(AKTAttributeItemType_Right);
}

void __andWidth_imp__() {
    addItemType(AKTAttributeItemType_Width);
}

void __andHeight_imp__() {
    addItemType(AKTAttributeItemType_Height);
}

void __andWHRatio_imp__() {
    addItemType(AKTAttributeItemType_WHRatio);
}

void __andCenterX_imp__() {
    addItemType(AKTAttributeItemType_CenterX);
}

void __andCenterY_imp__() {
    addItemType(AKTAttributeItemType_CenterY);
}

void __andCenterXY_imp__() {
    addItemType(AKTAttributeItemType_CenterXY);
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
void __equalTo_imp__(AKTReference reference) {
    BOOL isDynamic = attributeRef_global->layoutDynamicContextBegin;
    AKTAttributeItemRef itemRef;
    if (isDynamic) {
        itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
    }else{
        itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
    }
    if (!reference.referenceValidate) {
        UIView *bindView = (__bridge UIView *)(itemRef->bindView);
        NSString *description = [NSString stringWithFormat:@"> %@: Refefence infomation invalide! 当前获取的参考信息无效", bindView.aktName];
        NSString *suggest = [NSString stringWithFormat:@"> The correct way to get reference information: akt_size(), akt_value()...,view1.akt_top, view1.akt_height...\n> 正确获取参考信息的方式有：akt_size(), akt_value()...,view1.akt_top, view1.akt_height..."];
        __aktErrorReporter(200, description, suggest);
        return;
    }
    // If added edgeinset item type, and reference types are: "NSNumber", "NSVale", "AKT ViewAttribute", the reference set is invalid.
    // 如果设置了edgeinset，并且参考类型是："NSNumber", "NSValue", "AKTViewAttribute",则参照设置是无效的
    BOOL (^edgeCheck)() = ^(){
        if (itemRef->configuration.referenceEdgeInsert.top<(FLT_MAX-1)) {
            UIView *bindView = (__bridge UIView *)(itemRef->bindView);
            NSString *description = [NSString stringWithFormat:@"> %@: Reference types and reference information does not correspond, for setting \"edge\" referenced to \"Constant\" or \"ViewAttribute\" makes no sense\n> 参照类型和参照信息不对应,对于edge设置参考Constant或者ViewAttribute是没有意义的", bindView.aktName];
            NSString *sugget = [NSString stringWithFormat:@"> For more details, please refer to the error message described in the document. 详情请参考错误信息描述文档"];
            __aktErrorReporter(201, description, sugget);
            return YES;
        }
        return NO;
    };
    // If added size item type, and reference types are: "NSNumber", "AKT ViewAttribute", the reference set is invalid.
    // 如果设置了size，并且参考类型是："NSNumber", "AKTViewAttribute",则参照设置是无效的
    BOOL (^sizeCheck)() = ^(){
        if (itemRef->configuration.reference.referenceSize.width<(FLT_MAX-1)) {
            UIView *bindView = (__bridge UIView *)(itemRef->bindView);
            NSString *description = [NSString stringWithFormat:@"> %@: Reference types and reference information does not correspond, for setting \"size\" referenced to \"Constant\" or \"ViewAttribute\" makes no sense\n> 参照类型和参照信息不对应,对于size设置参考Constant或者ViewAttribute是没有意义的", bindView.aktName];
            NSString *sugget = [NSString stringWithFormat:@"> For more details, please refer to the error message described in the document. 详情请参考错误信息描述文档"];
            __aktErrorReporter(202, description, sugget);
            return YES;
        }
        return NO;
    };

    switch (reference.referenceType) {
        case AKTRefenceType_View:
            // Add reference view
            if(itemRef->configuration.reference.referenceSize.width<FLT_MAX-1) reference.referenceSize = itemRef->configuration.reference.referenceSize;
            itemRef->configuration.reference = reference;
            return;
            break;
        case AKTRefenceType_Constant:// value and size
        {
            // If added edgeinset reference type, these references setted are invalid. You must reference to a view.
            // 如果设置了edgeinset参考类型，则设置这些参考是无效的，必须设置一个view为参照
            if (edgeCheck()) {
                return;
            }
            // 布局项有size类型
            if (itemRef->configuration.reference.referenceSize.width<FLT_MAX-1) {
                // 设置非size参考
                if (reference.referenceValue<FLT_MAX-1) {
                    UIView *bindView = (__bridge UIView *)(itemRef->bindView);
                    NSString *description = [NSString stringWithFormat:@"> %@: Reference types and reference information does not correspond, for setting \"size\" referenced to \"Constant\" or \"ViewAttribute\" makes no sense\n> 参照类型和参照信息不对应,对于size设置参考Constant或者ViewAttribute是没有意义的", bindView.aktName];
                    NSString *sugget = [NSString stringWithFormat:@"> For more details, please refer to the error message described in the document. 详情请参考错误信息描述文档"];
                    __aktErrorReporter(202, description, sugget);
                    return;
                }
            }else{
                // 设置size参考
                if (reference.referenceSize.width<FLT_MAX-1) {
                    UIView *bindView = (__bridge UIView *)(itemRef->bindView);
                    NSString *description = [NSString stringWithFormat:@"> %@: Reference types and reference information does not correspond, for setting \"top、left、bottom...\" referenced to \"size\" makes no sense\n> 参照类型和参照信息不对应,对于top、left、bottom...设置参考size是没有意义的", bindView.aktName];
                    NSString *sugget = [NSString stringWithFormat:@"> For more details, please refer to the error message described in the document. 详情请参考错误信息描述文档"];
                    __aktErrorReporter(203, description, sugget);
                    return;
                }
            }
            // Add reference constant
            itemRef->configuration.reference = reference;
            return;
        }
            break;
        case AKTRefenceType_ViewAttribute:
            // If added edgeinset and size constraints, these references setted are invalid. You must reference to a view.
            // 如果设置了edgeinset和size约束，则设置这些参考是无效的，必须设置一个view为参照
            if (edgeCheck() || sizeCheck()) {
                return;
            }
            itemRef->configuration.reference = reference;
            return;
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
void addItemType(AKTAttributeItemType type) {
    BOOL isDynamic = attributeRef_global->layoutDynamicContextBegin;
    AKTAttributeItemRef itemRef;
    if (isDynamic) {
        itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
    }else{
        itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
    }
    // Check whether out of range
    if (itemRef->typeCount==kTypeMaximum) {
        UIView *bindView = (__bridge UIView *)itemRef->bindView;
        NSString *description = [NSString stringWithFormat:@"> %@: Out of the range of attributeItemType array.(%@)\n> \"attributeItemType\"数组越界(%@)",isDynamic? @"dynamic part":@"static part", bindView.aktName, isDynamic? @"动态部分":@"静态部分"];
        NSString *sugget = [NSString stringWithFormat:@"> You add too much reference item at once. For more details, please refer to the error message described in the document. 一次添加了过多的参照项，详情请参考错误信息描述文档"];
        __aktErrorReporter(300, description, sugget);
        return;
    }
    // Add itemType to itemInfo
    itemRef->typeArray[itemRef->typeCount] = type;
    itemRef->typeCount++;
    return;
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
CGFloat calculate(CGFloat origin, CGFloat multiple, CGFloat coefficientOffset, CGFloat offset) {
    return (origin+coefficientOffset)*multiple+offset;
}
//---------------------------------------------------------
@implementation AKTViewAttribute
@end
