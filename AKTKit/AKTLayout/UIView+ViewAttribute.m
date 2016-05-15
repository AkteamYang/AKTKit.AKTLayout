//
//  UIView+ViewAttribute.m
//  AKTLayout
//
//  Created by YaHaoo on 16/4/16.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

// import-<frameworks.h>
#import <objc/runtime.h>
// import-"models.h"
#import "AKTLayoutAttribute.h"
// import-"views & controllers.h"
#import "UIView+ViewAttribute.h"
// import-"aid.h"
#import "NSObject+AKT.h"
#import "AKTPublic.h"

//--------------------Structs statement, globle variables...--------------------
static char * const AKT_ADAPTIVE_WIDTH = "AKT_ADAPTIVE_WIDTH";
static char * const AKT_ADAPTIVE_HEIGHT = "AKT_ADAPTIVE_HEIGHT";
static char * const kAktName = "aktName";
static char * const kLayoutChain = "kLayoutChain";
static char * const kAttributeRef = "kAttributeRef";
static char * const kViewsReferenced = "kViewsReferenced";
static const char kLayoutUpdateCount;
//-------------------- E.n.d -------------------->Structs statement & globle variables

@implementation UIView (ViewAttribute)
+ (void)load {
    [UIView swizzleClass:[UIView class] fromMethod:@selector(setFrame:) toMethod:@selector(setNewFrame:)];
}

#pragma mark - property settings
//|---------------------------------------------------------
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

/**
 *  自适应宽度
 *
 *  @return @YES or @NO
 */
- (NSNumber *)adaptiveWidth {
    return objc_getAssociatedObject(self, AKT_ADAPTIVE_WIDTH);
}

- (void)setAdaptiveWidth:(NSNumber *)adaptiveWidth {
    objc_setAssociatedObject(self, AKT_ADAPTIVE_WIDTH, adaptiveWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  自适应高度
 *
 *  @return @YES or @NO
 */
- (NSNumber *)adaptiveHeight {
    return objc_getAssociatedObject(self, AKT_ADAPTIVE_HEIGHT);
}

- (void)setAdaptiveHeight:(NSNumber *)adaptiveHeight {
    objc_setAssociatedObject(self, AKT_ADAPTIVE_HEIGHT, adaptiveHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  AKTLayout Debug日志将用此名称进行打印日志
 *
 *  @return AKTLayout 日志打印名称
 */
- (NSString *)aktName {
    NSString *str = objc_getAssociatedObject(self, kAktName);
    return str? str:[NSString stringWithFormat:@"%@:%p",NSStringFromClass(self.class),self];;
}

- (void)setAktName:(NSString *)aktName {
    objc_setAssociatedObject(self, kAktName, aktName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  布局链, 包含了参考了当前视图的布局，当当前视图布局改变时将刷新链表中的视图的布局。
 *
 *  @return 布局视图的数组
 */
- (NSMutableArray *)layoutChain {
    NSMutableArray *arr = objc_getAssociatedObject(self, kLayoutChain);
    if (!arr) {
        arr = [NSMutableArray array];
        objc_setAssociatedObject(self, kLayoutChain, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arr;
}

/**
 *  当前视图所参考的视图的数组
 *
 *  @return 当前视图所参考的视图的数组
 */
- (NSMutableArray *)viewsReferenced {
    NSMutableArray *arr = objc_getAssociatedObject(self, kViewsReferenced);
    if (!arr) {
        arr = [NSMutableArray array];
        objc_setAssociatedObject(self, kViewsReferenced, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arr;
}

/**
 *  AKTLayout 布局信息结构体指针
 *
 *  @return AKTLayout 布局信息结构体指针
 */
- (void *)attributeRef {
    NSValue *value = objc_getAssociatedObject(self, kAttributeRef);
    return value? value.pointerValue:NULL;
}

- (void)setAttributeRef:(void *)attributeRef {
    if (attributeRef) {
        objc_setAssociatedObject(self, kAttributeRef, [NSValue valueWithPointer:attributeRef], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

/**
 *  布局需要被刷新次数
 *  @备注：在所参考视图变化时，会先计算当前视图会被刷新次数，当计数器大于1时表示暂时不必更新布局，等于1时更新布局并归0，默认状态为0;
 *
 *  @return 布局需要刷新次数
 */
- (NSInteger)layoutUpdateCount {
    NSNumber *count = objc_getAssociatedObject(self, &kLayoutUpdateCount);
    return count? [count integerValue]:0;
}

- (void)setLayoutUpdateCount:(NSInteger)layoutUpdateCount {
    objc_setAssociatedObject(self, &kLayoutUpdateCount, @(layoutUpdateCount<0? 0:layoutUpdateCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    // 设置相关视图的布局更新计数器
    // @备注：如果当前视图是触发布局更新的事件源，则需要设置参考了当前视图的视图的更新计数器
    if (self.layoutUpdateCount==0) {
        NSLog(@"View start update related views akt tag: %ld name: %@", self.tag, self.aktName);
        [self aktSetLayoutUpdateCount];
    }
    // 刷新子节点布局
    for (int i = 0; i< count;i++) {
        UIView *bindView = self.layoutChain[i];
        // 如果bindView的布局更新计数器大于0，则暂时不必计算布局更新
        if (bindView.layoutUpdateCount>1) {
            bindView.layoutUpdateCount--;
            continue;
        }
//        if ([bindView.aktName hasPrefix:@"akt"]) {
//            NSLog(@"akt tag: %ld name: %@", bindView.tag, bindView.aktName);
//            static int count = 0;
//            count++;
//            NSLog(@"count: %d", count);
//        }
        CGRect rect;
        rect = calculateAttribute(bindView.attributeRef);
        bindView.frame = rect;
        // Frame更新完之后将更新计数器减1
        bindView.layoutUpdateCount--;
    }
}

/**
 *  设置参考了本视图的相关视图的布局刷新计数器
 *  @备注：包含所有布局建立在当前视图基础上的视图（直接或间接参考了当前视图的视图）
 */
- (void)aktSetLayoutUpdateCount {
    for(UIView *nodeView in self.layoutChain) {
        nodeView.layoutUpdateCount++;
//        NSLog(@"tag: %ld, nodeView: %@ count: %ld",nodeView.tag, nodeView.aktName, nodeView.layoutUpdateCount);
        // 当nodeView的视图刷新次数大于1时不必再向下迭代增加子节点的布局更新次数，因为在必要时nodeView只刷新一次
        if (nodeView.layoutUpdateCount>1) continue;
        // NodeView首次设置刷新时，为子节点添加刷新计数
        [nodeView aktSetLayoutUpdateCount];
    }
}

/**
 *  监控当前视图frame的变化
 *
 *  @param frame 新的frame
 */
- (void)setNewFrame:(CGRect)frame {
    CGRect old = self.frame;
    CGRect new = frame;
    if (mAKT_EQ(old.size.width, new.size.width) && mAKT_EQ(old.size.height, new.size.height) && mAKT_EQ(old.origin.x, new.origin.x) && mAKT_EQ(old.origin.y, new.origin.y)) {
        return;
    }
    [self setNewFrame:frame];
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
