//
//  UIView+ViewAttribute.m
//  AKTLayout
//
//  Created by YaHaoo on 16/4/16.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "UIView+ViewAttribute.h"
#import <objc/runtime.h>
#import "AKTPublic.h"
#import "AKTLayoutAttribute.h"
#import "NSObject+AKT.h"

//--------------------Structs statement, globle variables...--------------------
static char * const AKT_ADAPTIVE_WIDTH = "AKT_ADAPTIVE_WIDTH";
static char * const AKT_ADAPTIVE_HEIGHT = "AKT_ADAPTIVE_HEIGHT";
static char * const kAktName = "aktName";
static char * const kLayoutChain = "kLayoutChain";
static char * const kAttributeRef = "kAttributeRef";
static char * const kViewsReferenced = "kViewsReferenced";
//-------------------- E.n.d -------------------->Structs statement & globle variables
@implementation UIView (ViewAttribute)
+ (void)load {
    [UIView swizzleClass:[UIView class] fromMethod:@selector(setFrame:) toMethod:@selector(setNewFrame:)];
}

#pragma mark - properties
/**
 *Properties related to frame
 */

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (NSNumber *)adaptiveWidth {
    return objc_getAssociatedObject(self, AKT_ADAPTIVE_WIDTH);
}

- (void)setAdaptiveWidth:(NSNumber *)adaptiveWidth {
    objc_setAssociatedObject(self, AKT_ADAPTIVE_WIDTH, adaptiveWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)adaptiveHeight {
    return objc_getAssociatedObject(self, AKT_ADAPTIVE_HEIGHT);
}

- (void)setAdaptiveHeight:(NSNumber *)adaptiveHeight {
    objc_setAssociatedObject(self, AKT_ADAPTIVE_HEIGHT, adaptiveHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)aktName {
    NSString *str = objc_getAssociatedObject(self, kAktName);
    return str? str:[NSString stringWithFormat:@"%@:%p",NSStringFromClass(self.class),self];;
}

- (void)setAktName:(NSString *)aktName {
    objc_setAssociatedObject(self, kAktName, aktName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableArray *)layoutChain {
    NSMutableArray *arr = objc_getAssociatedObject(self, kLayoutChain);
    if (!arr) {
        arr = [NSMutableArray array];
        objc_setAssociatedObject(self, kLayoutChain, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arr;
}

- (NSMutableArray *)viewsReferenced {
    NSMutableArray *arr = objc_getAssociatedObject(self, kViewsReferenced);
    if (!arr) {
        arr = [NSMutableArray array];
        objc_setAssociatedObject(self, kViewsReferenced, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arr;
}

- (void *)attributeRef {
    NSValue *value = objc_getAssociatedObject(self, kAttributeRef);
    return value? value.pointerValue:NULL;
}

- (void)setAttributeRef:(void *)attributeRef {
    if (attributeRef) {
        objc_setAssociatedObject(self, kAttributeRef, [NSValue valueWithPointer:attributeRef], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - Quick layout
//|---------------------------------------------------------
/**
 *  快速布局
 *
 *  @param type          快速布局约束类型
 *  @param referenceView 参考视图
 *  @param offset        偏移值
 */
- (void)AKTQuickLayoutWithType:(QuickLayoutConstraintType)type referenceView:(UIView *)referenceView offset:(CGFloat)offset {
    switch (type) {
        case QuickLayoutConstraintAlignTo_Top:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + offset;
            }else{
                self.y = offset;
            }
            break;
        case QuickLayoutConstraintAlignTo_Left:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + offset;
            }else{
                self.x = offset;
            }
            break;
        case QuickLayoutConstraintAlignTo_Bottom:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + referenceView.height + offset - self.height;
            }else{
                self.y = offset + referenceView.height - self.height;
            }
            break;
        case QuickLayoutConstraintAlignTo_Right:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + referenceView.width + offset - self.width;
            }else{
                self.x = offset + referenceView.width - self.width;
            }
            break;
        case QuickLayoutConstraintSpaceTo_Top:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + offset - self.height;
            }else{
                self.y = offset - self.height;
            }
            break;
        case QuickLayoutConstraintSpaceTo_Left:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + offset - self.width;
            }else{
                self.x = offset - self.width;
            }
            break;
        case QuickLayoutConstraintSpaceTo_Bottom:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + offset + referenceView.height;
            }else{
                self.y = offset + referenceView.height;
            }
            break;
        case QuickLayoutConstraintSpaceTo_Right:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + offset + referenceView.width;
            }else{
                self.x = offset + referenceView.width;
            }
            break;
        case QuickLayoutConstraintAlign_Horizontal:
            if (self.superview == referenceView.superview) {
                self.y = referenceView.y + offset + referenceView.height/2-self.height/2;
            }else{
                self.y = offset + referenceView.height/2-self.height/2;
            }
            break;
        case QuickLayoutConstraintAlign_Vertical:
            if (self.superview == referenceView.superview) {
                self.x = referenceView.x + offset + referenceView.width/2-self.width/2;
            }else{
                self.x = offset + referenceView.width/2-self.width/2;
            }
            break;
        default:
            break;
    }
}

#pragma mark - auto update node
//|---------------------------------------------------------
/**
 *  刷新布局子节点（刷新参考了本视图的视图）
 */
- (void)aktUpdateLayoutChainNode {
    NSInteger count = self.layoutChain.count;
    if (count<=0) {
        return;
    }
    //    NSLog(@"%@ updete layout chain node", self.aktName);
    for (int i = 0; i< count;i++) {
        UIView *bindView = self.layoutChain[i];
        //        NSLog(@"%@ node will update frame", bindView.aktName);
        CGRect rect;
        rect = calculateAttribute(bindView.attributeRef);
        bindView.frame = rect;
    }
}

/**
 *  监控当前视图frame的变化
 *
 *  @param frame 新的frame
 */
- (void)setNewFrame:(CGRect)frame {
    //    NSLog(@"%@ set frame layoutCount: %ld",self.aktName, self.layoutCount);
    CGRect old = self.frame;
    CGRect new = frame;
    if (mAKT_EQ(old.size.width, new.size.width) && mAKT_EQ(old.size.height, new.size.height) && mAKT_EQ(old.origin.x, new.origin.x) && mAKT_EQ(old.origin.y, new.origin.y)) {
        return;
    }
    //    NSLog(@"%@ set new frame:%@",self.aktName, NSStringFromCGRect(frame));
    [self setNewFrame:frame];
    // If frame changed call method "aktViewLayout".
    // 如果frame发生的改变，则更新布局链节点布局
    [self aktUpdateLayoutChainNode];
}

/**
 *  从父视图中销毁（我们需要最终销毁视图时调用，从父视图中移除并且删除AKTLayout信息）
 *  提醒：当我们pop、dismiss视图控制器的时候，会自动调用被释放控制器的view的"aktRemoveAKTLayout"，这种情况下无需手动调用。
 */
- (void)aktDestroyFromSuperView {
    // 移除自身和子视图AKTLayout布局
    [self aktRemoveFromSuperView];
    // 从父视图中移除
    [self removeFromSuperview];
}

/**
 *  移除当前视图及子视图的AKTLayout布局
 *  提醒：当我们pop、dismiss视图控制器的时候，会自动调用被释放控制器的view的"aktRemoveAKTLayout"，这种情况下无需手动调用。
 */
- (void)aktRemoveFromSuperView {
    //    NSLog(@"%@ did remove frome superview",self.aktName);
    if (self.attributeRef) {
        // Free layout attribute.
        AKTLayoutAttributeRef ref = self.attributeRef;
        CFRelease(ref->bindView);
        free(self.attributeRef);
        self.attributeRef = NULL;
    }
    // Remove from reference view's layout chain.
    for (UIView *referenceView in self.viewsReferenced) {
        [referenceView.layoutChain removeObject:self];
    }
    [self.viewsReferenced removeAllObjects];
    // Remove from node's view reference.
    for (UIView *node in self.layoutChain) {
        [node.viewsReferenced removeObject:self];
    }
    [self.layoutChain removeAllObjects];
    // 移除子视图的 AKTLayout.
    for (UIView *view in self.subviews) {
        if (view.attributeRef) {
            [view aktRemoveFromSuperView];
        }
    }
}
@end
