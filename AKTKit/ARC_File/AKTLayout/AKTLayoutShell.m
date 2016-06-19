//
//  AKTLayoutShellAttribute.m
//  Test
//
//  Created by YaHaoo on 16/4/19.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTLayoutShell.h"

//--------------------Structs statement, globle variables...--------------------
id configure_shell = nil;
id item_shell      = nil;
id attribute_shell = nil;
extern AKTLayoutAttributeRef attributeRef_global;
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@implementation AKTLayoutShellConfigure
AKTLayoutShellConfigure *sharedConfigure() {
    if (!configure_shell) {
        configure_shell = [AKTLayoutShellConfigure new];
    }
    return configure_shell;
}

/*
 * Multiple and offset
 */
- (AKTLayoutShellConfigure *(^)(CGFloat obj))multiple {
    return ^AKTLayoutShellConfigure *(CGFloat obj){
        AKTAttributeItemRef itemRef;
        if (attributeRef_global->layoutDynamicContextBegin) {
            itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
        }else{
            itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
        }
        itemRef->configuration.referenceMultiple = obj;
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(CGFloat obj))offset {
    return ^AKTLayoutShellConfigure *(CGFloat obj){
        AKTAttributeItemRef itemRef;
        if (attributeRef_global->layoutDynamicContextBegin) {
            itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
        }else{
            itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
        }
        itemRef->configuration.referenceOffset = obj;
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(CGFloat obj))coefficientOffset {
    return ^AKTLayoutShellConfigure *(CGFloat obj){
        AKTAttributeItemRef itemRef;
            if (attributeRef_global->layoutDynamicContextBegin) {
                itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
            }else{
                itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
            }
            itemRef->configuration.referenceCoefficientOffset = obj;
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(UIEdgeInsets inset))edgeInset {
    return ^AKTLayoutShellConfigure *(UIEdgeInsets inset){
        AKTAttributeItemRef itemRef;
            if (attributeRef_global->layoutDynamicContextBegin) {
                itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
            }else{
                itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
            }
            itemRef->configuration.referenceEdgeInsert = inset;
        return configure_shell? configure_shell:sharedConfigure();
    };
}
@end

@implementation AKTLayoutShellItem
AKTLayoutShellItem *sharedShellItem() {
    if (!item_shell) {
        item_shell = [AKTLayoutShellItem new];
    }
    return item_shell;
}

// Configure layout attribute item
- (AKTLayoutShellItem *)top {
        __andTop_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)left {
        __andLeft_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)bottom {
        __andBottom_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)right {
        __andRight_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)width {
        __andWidth_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)height{
        __andHeight_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)whRatio {
        __andWHRatio_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerX {
        __andCenterX_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerY {
        __andCenterY_imp__();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerXY {
        __andCenterXY_imp__();
    return item_shell? item_shell:sharedShellItem();
}

// End set layout attribute item and set reference object
- (AKTLayoutShellConfigure *(^)(AKTReference reference))equalTo {
    return ^AKTLayoutShellConfigure *(AKTReference reference) {
            __equalTo_imp__(reference);
                return configure_shell? configure_shell:sharedConfigure();
    };
}
@end

@implementation AKTLayoutShellAttribute
AKTLayoutShellAttribute *sharedShellAttribute() {
    if (!attribute_shell) {
        attribute_shell = [AKTLayoutShellAttribute new];
    }
    return attribute_shell;
}

/*
 * Create layout attribute item
 */
- (AKTLayoutShellItem *)top {
        __akt__create__top();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)left {
        __akt__create__left();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)bottom {
        __akt__create__bottom();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)right {
        __akt__create__right();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)width {
        __akt__create__width();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)height {
        __akt__create__height();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)whRatio {
        __akt__create__whRatio();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerX {
        __akt__create__centerX();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerY {
        __akt__create__centerY();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerXY {
        __akt__create__centerXY();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)edge {
        __akt__create__edge();
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)size {
        __akt__create__size();
    return item_shell? item_shell:sharedShellItem();
}

/**
 *  Add dynamic layout for view. Layout info will be update when needed.
 *  @note: When the condition returned YES, attribute will be update to the view's layout info storage.
 *
 *  @param condition Condition for updating layout info.
 *  @param attribute Block for updateing layout info.
 */
- (void)addDynamicLayoutInCondition:(BOOL(^)())condition andAttribute:(void(^)(AKTLayoutShellAttribute *dynamicLayout))attribute {
    if (!condition || !attribute || attributeRef_global->blockCountForDynamic>=kItemMaximum) {
        return;
    }
    // Save blocks for refreshing dynamic layout.
    AKTDynamicLayoutBlock *block = attributeRef_global->blockArrayForDynamic+attributeRef_global->blockCountForDynamic;
    block->conditionBlock = CFBridgingRetain(condition);
    block->attributeBlock = CFBridgingRetain(attribute);
    attributeRef_global->blockCountForDynamic++;
}
@end
