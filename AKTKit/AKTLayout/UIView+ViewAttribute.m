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
#import "AKTAsyncDispatcher.h"
#import "NSObject+AKT.h"

//--------------------Structs statement, globle variables...--------------------
static char * const AKT_ADAPTIVE_WIDTH = "AKT_ADAPTIVE_WIDTH";
static char * const AKT_ADAPTIVE_HEIGHT = "AKT_ADAPTIVE_HEIGHT";
static char * const kAktName = "aktName";
static char * const kLayoutChain = "kLayoutChain";
static char * const kAttributeRef = "kAttributeRef";
static char * const kViewsReferenced = "kViewsReferenced";
static char * const kLayoutComplete = "kLayoutComplete";
static char * const kLayoutCount = "kLayoutCount";
static char * const kLayoutActive = "kLayoutActive";
//-------------------- E.n.d -------------------->Structs statement & globle variables
@implementation UIView (ViewAttribute)
+ (void)load {
    [UIView swizzleClass:[UIView class] fromMethod:@selector(setFrame:) toMethod:@selector(setNewFrame:)];
    [UIView swizzleClass:[UIView class] fromMethod:@selector(removeFromSuperview) toMethod:@selector(aktRemoveFromSuperview)];
    [UIView swizzleClass:[UIView class] fromMethod:@selector(addSubview:) toMethod:@selector(aktAddSubview:)];
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

//- (NSInteger)layoutCount {
//    id obj = objc_getAssociatedObject(self, kLayoutCount);
//    if (!obj) {
//        return self.layoutChain.count;
//    }
//    return [obj integerValue];
//}

//- (void)setLayoutCount:(NSInteger)layoutingCount {
//    objc_setAssociatedObject(self, kLayoutCount, @(layoutingCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    if ((layoutingCount == self.layoutChain.count) && !self.layoutActive) {
//        NSLog(@"%@ layout complete", self.aktName);
//        
//        BOOL(^block)();
//        NSArray *blocks = self.layoutComplete;
//        if (blocks.count>0) {
//            for (id obj in blocks) {
//                block = obj;
//                if (block()) {// 有退出命令，退出，只有执行了"removeFromeSuperview"才会退出。
//                    return;
//                }
//            }
//            // 恢复激活状态
//            self.layoutActive = YES;
//            NSLog(@"%@ 恢复激活状态", self.aktName);
//        }
//    }
//}

- (BOOL)layoutActive {
    id obj = objc_getAssociatedObject(self, kLayoutActive);
    if (!obj) {
        return YES;
    }
    return [obj boolValue];
}

- (void)setLayoutActive:(BOOL)layoutActive {
    objc_setAssociatedObject(self, kLayoutActive, @(layoutActive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)layoutComplete {
    NSMutableArray *arr = objc_getAssociatedObject(self, kLayoutComplete);
    if (!arr) {
        arr = [NSMutableArray array];
        objc_setAssociatedObject(self, kLayoutComplete, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arr;
}
#pragma mark - Quick layout
//|---------------------------------------------------------
/**
 *  Layout
 *
 *  @param type          layout type
 *  @param referenceView reference view
 *  @param offset        offset
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
 *  Update layout of the node in the view's layout chain.
 *  刷新布局链节点布局
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
        if (!bindView.layoutActive) {
            continue;
        }
        // 改变参考视图布局计数器
        //        for (UIView *reference in bindView.viewsReferenced) {
        //            NSLog(@"%@ referencelayoutCount--", reference.aktName);
        //            reference.layoutCount--;
        //        }
        //        bindView.layoutCount--;
        CGRect rect;
        rect = calculateAttribute(bindView.attributeRef);
        bindView.frame = rect;
        //        bindView.layoutCount++;
        //        for (UIView *reference in bindView.viewsReferenced) {
        //            reference.layoutCount++;
        //        }
    }
}

/**
 *  Observer for frame change
 *
 *  @param frame new frame
 */
- (void)setNewFrame:(CGRect)frame {
//    // Couldn't change frame on unactive mode.
//    // 非激活模式下不能改变frame
//    if (!self.layoutActive) {
//        return;
//    }
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

- (void)aktRemoveFromSuperview {
    [self aktRemoveFromSuperview];
    //    NSLog(@"%@ did remove frome superview",self.aktName);
    //
    //    BOOL (^block)() = ^{
    //        NSLog(@"%@ remove frome superview block start",self.aktName);
    if (self.attributeRef) {
        // Free layout attribute.
        AKTLayoutAttributeRef ref = self.attributeRef;
        CFRelease(ref->bindView);
        free(self.attributeRef);
        self.attributeRef = NULL;
    }
    // Reset properties(layoutActive needn't change status)
    self.adaptiveWidth = @YES;
    self.adaptiveHeight = @YES;
//    self.layoutCount = 0;
    [self.layoutComplete removeAllObjects];
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
    // 移除所有添加了akt布局的view
    for (UIView *view in self.subviews) {
        if (view.attributeRef) {
            [view removeFromSuperview];
        }
    }
    //        return YES;
    //    };
    //    if (self.layoutCount>=self.layoutChain.count) {
    //        block();
    //        return;
    //    }
    //    NSLog(@"%@ add block remove frome superview, aktlayoutCount:%ld",self.aktName, self.layoutCount);
    //    self.layoutActive = NO;
    //    [self.layoutComplete addObject:block];
}

- (void)aktAddSubview:(UIView *)view {
    if (!self.layoutActive) {
        mAKT_Log(@"%@\n// Current view \"layoutActive\" state is not available, it may be will be destroyed or are ready layout operation\n// 当前视图layoutActive状态不可用, 可能是已经准备销毁或者正在运算布局", self.aktName);
        [self aktAddSubview:nil];
        return;
    }
    //    NSLog(@"%@ did add to superview",self.aktName);
    [self aktAddSubview:view];
}
@end
