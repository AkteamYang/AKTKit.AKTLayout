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
bool needGetLayoutInfo_sheel = true;
extern AKTLayoutAttributeRef attributeRef_global;
//-------------------- E.n.d -------------------->Structs statement, globle variables...

void aktDynamicLayoutBeginContextWithIdentifier(long identifier) {
    attributeRef_global->layoutDynamicContextBegin = true;
    if (identifier == attributeRef_global->layoutInfoTag) {
        // needGetLayoutInfo_sheel = false by default. Will update nothing.
        nil;
    }else{
        attributeRef_global->layoutInfoTag = identifier;
        attributeRef_global->itemCountForDynamic = 0;
        attributeRef_global->check = false;
        needGetLayoutInfo_sheel = true;
    }
}

void aktDynamicLayoutEndContext() {
    needGetLayoutInfo_sheel = false;
    attributeRef_global->layoutDynamicContextBegin = false;
}

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
        if (needGetLayoutInfo_sheel) {
            if (attributeRef_global->layoutDynamicContextBegin) {
                itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
            }else{
                itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
            }
            itemRef->configuration.referenceMultiple = obj;
        }
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(CGFloat obj))offset {
    return ^AKTLayoutShellConfigure *(CGFloat obj){
        AKTAttributeItemRef itemRef;
        if (needGetLayoutInfo_sheel) {
            if (attributeRef_global->layoutDynamicContextBegin) {
                itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
            }else{
                itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
            }
            itemRef->configuration.referenceOffset = obj;
        }
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(CGFloat obj))coefficientOffset {
    return ^AKTLayoutShellConfigure *(CGFloat obj){
        AKTAttributeItemRef itemRef;
        if (needGetLayoutInfo_sheel) {
            if (attributeRef_global->layoutDynamicContextBegin) {
                itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
            }else{
                itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
            }
            itemRef->configuration.referenceCoefficientOffset = obj;
        }
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(UIEdgeInsets inset))edgeInset {
    return ^AKTLayoutShellConfigure *(UIEdgeInsets inset){
        AKTAttributeItemRef itemRef;
        if (needGetLayoutInfo_sheel) {
            if (attributeRef_global->layoutDynamicContextBegin) {
                itemRef = attributeRef_global->itemArrayForDynamic+attributeRef_global->itemCountForDynamic-1;
            }else{
                itemRef = attributeRef_global->itemArrayForStatic+attributeRef_global->itemCountForStatic-1;
            }
            itemRef->configuration.referenceEdgeInsert = inset;
        }
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
    if (needGetLayoutInfo_sheel) {
        __andTop_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)left {
    if (needGetLayoutInfo_sheel) {
        __andLeft_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)bottom {
    if (needGetLayoutInfo_sheel) {
        __andBottom_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)right {
    if (needGetLayoutInfo_sheel) {
        __andRight_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)width {
    if (needGetLayoutInfo_sheel) {
        __andWidth_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)height{
    if (needGetLayoutInfo_sheel) {
        __andHeight_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)whRatio {
    if (needGetLayoutInfo_sheel) {
        __andWHRatio_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerX {
    if (needGetLayoutInfo_sheel) {
        __andCenterX_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerY {
    if (needGetLayoutInfo_sheel) {
        __andCenterY_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerXY {
    if (needGetLayoutInfo_sheel) {
        __andCenterXY_imp__();
    }
    return item_shell? item_shell:sharedShellItem();
}

// End set layout attribute item and set reference object
- (AKTLayoutShellConfigure *(^)(AKTReference reference))equalTo {
    return ^AKTLayoutShellConfigure *(AKTReference reference) {
        if (needGetLayoutInfo_sheel) {
            __equalTo_imp__(reference);
        }
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
    if (needGetLayoutInfo_sheel) {
        __akt__create__top();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)left {
    if (needGetLayoutInfo_sheel) {
        __akt__create__left();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)bottom {
    if (needGetLayoutInfo_sheel) {
        __akt__create__bottom();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)right {
    if (needGetLayoutInfo_sheel) {
        __akt__create__right();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)width {
    if (needGetLayoutInfo_sheel) {
        __akt__create__width();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)height {
    if (needGetLayoutInfo_sheel) {
        __akt__create__height();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)whRatio {
    if (needGetLayoutInfo_sheel) {
        __akt__create__whRatio();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerX {
    if (needGetLayoutInfo_sheel) {
        __akt__create__centerX();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerY {
    if (needGetLayoutInfo_sheel) {
        __akt__create__centerY();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)centerXY {
    if (needGetLayoutInfo_sheel) {
        __akt__create__centerXY();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)edge {
    if (needGetLayoutInfo_sheel) {
        __akt__create__edge();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (AKTLayoutShellItem *)size {
    if (needGetLayoutInfo_sheel) {
        __akt__create__size();
    }
    return item_shell? item_shell:sharedShellItem();
}

- (void)aktLayoutIdentifier:(long)identifier withDynamicAttribute:(void(^)())attribute {
    if (!attribute) return;
    if(attributeRef_global->layoutInfoFetchBlock){
        long temp = attributeRef_global->layoutInfoTag;
        aktDynamicLayoutBeginContextWithIdentifier(identifier);
        if (temp!=attributeRef_global->layoutInfoTag) {
            attribute();
        }
        aktDynamicLayoutEndContext();
        nil;
    }else{// 首次获取全部布局信息(包括动态和静态布局信息),继续获取剩余的静态布局信息
        aktDynamicLayoutBeginContextWithIdentifier(identifier);
        attribute();
        aktDynamicLayoutEndContext();
        needGetLayoutInfo_sheel = true;
    }
}
@end
