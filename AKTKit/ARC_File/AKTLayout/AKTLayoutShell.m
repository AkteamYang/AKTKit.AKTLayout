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
        AKTAttributeItemRef itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
        itemRef->configuration.referenceMultiple = obj;
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(CGFloat obj))offset {
    return ^AKTLayoutShellConfigure *(CGFloat obj){
        AKTAttributeItemRef itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
        itemRef->configuration.referenceOffset = obj;
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(CGFloat obj))coefficientOffset {
    return ^AKTLayoutShellConfigure *(CGFloat obj){
        AKTAttributeItemRef itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
        itemRef->configuration.referenceCoefficientOffset = obj;
        return configure_shell? configure_shell:sharedConfigure();
    };
}

- (AKTLayoutShellConfigure *(^)(UIEdgeInsets inset))edgeInset {
    return ^AKTLayoutShellConfigure *(UIEdgeInsets inset){
        AKTAttributeItemRef itemRef = attributeRef_global->itemArray+attributeRef_global->itemCount-1;
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
    bool b = __andTop_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)left {
    bool b = __andLeft_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)bottom {
    bool b = __andBottom_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)right {
    bool b = __andRight_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)width {
    bool b = __andWidth_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)height{
    bool b = __andHeight_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)whRatio {
    bool b = __andWHRatio_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)centerX {
    bool b = __andCenterX_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)centerY {
    bool b = __andCenterY_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)centerXY {
    bool b = __andCenterXY_imp__();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
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
    bool b = __akt__create__top();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)left {
    bool b = __akt__create__left();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)bottom {
    bool b = __akt__create__bottom();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)right {
    bool b = __akt__create__right();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)width {
    bool b = __akt__create__width();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)height {
    bool b = __akt__create__height();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)whRatio {
    bool b = __akt__create__whRatio();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)centerX {
    bool b = __akt__create__centerX();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)centerY {
    bool b = __akt__create__centerY();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)centerXY {
    bool b = __akt__create__centerXY();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)edge {
    bool b = __akt__create__edge();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

- (AKTLayoutShellItem *)size {
    bool b = __akt__create__size();
    return b? (item_shell? item_shell:sharedShellItem()):nil;
}

@end
