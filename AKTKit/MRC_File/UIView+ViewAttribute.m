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
#import "UIView+AKTLayout.h"

//--------------------Structs statement, globle variables...--------------------
static char * const AKT_ADAPTIVE_WIDTH  = "AKT_ADAPTIVE_WIDTH";
static char * const AKT_ADAPTIVE_HEIGHT = "AKT_ADAPTIVE_HEIGHT";
static char * const kLayoutChain        = "kLayoutChain";
static char * const kAttributeRef       = "kAttributeRef";
static char * const kViewsReferenced    = "kViewsReferenced";
static char const kAKTWeakContainer;
static const char kLayoutUpdateCount;
extern BOOL willCommitAnimation;
BOOL screenRotatingAnimationSupport     = YES;
BOOL screenRotating                     = NO;
//-------------------- E.n.d -------------------->Structs statement & globle variables

@implementation UIView (ViewAttribute)
+ (void)load {
    [UIView swizzleClass:[UIView class] fromMethod:@selector(setFrame:) toMethod:@selector(setNewFrame:)];
    [UIView swizzleClass:[UIView class] fromMethod:@selector(dealloc) toMethod:@selector(myDealloc)];
}

#pragma mark - property settings
//|---------------------------------------------------------
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

/**
 *  弱引用容器
 *
 *  @return
 */
- (AKTWeakContainer *)aktContainer {
    AKTWeakContainer *container = objc_getAssociatedObject(self, &kAKTWeakContainer);
    if (!container) {
        container = [[AKTWeakContainer new] autorelease];
        container.weakView = self;
        [self setAktContainer:container];
    }
    return container;
}

- (void)setAktContainer:(AKTWeakContainer *)aktContainer {
    objc_setAssociatedObject(self, &kAKTWeakContainer, aktContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - auto update node
//|---------------------------------------------------------
/**
 *  刷新布局子节点（刷新参考了本视图的视图）
 */
- (void)aktUpdateLayoutChainNode {
    NSInteger count = self.layoutChain.count;
    // 刷新子节点布局
    for (int i = 0; i< count;i++) {
        AKTWeakContainer *container = self.layoutChain[i];
        UIView *bindView = container.weakView;
        // 如果bindView的布局更新计数器大于0，则暂时不必计算布局更新
        NSInteger layoutUpdateCount = bindView.layoutUpdateCount;
        if (layoutUpdateCount>1) {
            bindView.layoutUpdateCount = layoutUpdateCount-1;
            continue;
        }
        // 是否需要同步运算（需要动画时、需要旋转时 或者 视图是UITableView 、 UICollectionView）
        if (willCommitAnimation || (screenRotatingAnimationSupport && screenRotating) || [bindView isKindOfClass:[UITableView class]] || [bindView isKindOfClass:[UICollectionView class]]) {
            CGRect rect = calculateAttribute(bindView.attributeRef);
            [bindView setFrame:rect];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect rect = calculateAttribute(bindView.attributeRef);
                [bindView setNewFrame:rect];
            });
            // 模拟设置frame，为了将计算传播下去，真正计算的是上面异步计算frame
            bindView.frame = CGRectMake(FLT_MAX, FLT_MAX, FLT_MAX, FLT_MAX);
        }
        // Frame更新完之后将更新计数器减1
        bindView.layoutUpdateCount = layoutUpdateCount-1;
    }
}

/**
 *  设置参考了本视图的相关视图的布局刷新计数器
 *  @备注：包含所有布局建立在当前视图基础上的视图（直接或间接参考了当前视图的视图）
 */
- (void)aktSetLayoutUpdateCount {
    for(AKTWeakContainer *container in self.layoutChain) {
        container.weakView.layoutUpdateCount++;
        // 当nodeView的视图刷新次数大于1时不必再向下迭代增加子节点的布局更新次数，因为在必要时nodeView只刷新一次
        if (container.weakView.layoutUpdateCount>1) continue;
        // NodeView首次设置刷新时，为子节点添加刷新计数
        [container.weakView aktSetLayoutUpdateCount];
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
    if(frame.origin.x>=FLT_MAX-1){
        // 这个frame设置仅仅为了通知当前view的相关view进行异步布局运算，而不必设置frame
        nil;
    }else{
        if (mAKT_EQ(old.size.width, new.size.width) && mAKT_EQ(old.size.height, new.size.height) && mAKT_EQ(old.origin.x, new.origin.x) && mAKT_EQ(old.origin.y, new.origin.y)) {
            return;
        }
        [self setNewFrame:frame];
    }
    //    NSLog(@"akt name: %@ new frame: %.1f, %.1f, %.1f, %.1f", self.aktName, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    NSInteger count = self.layoutChain.count;
    if (count<=0) {
        return;
    }
    // 设置相关视图的布局更新计数器
    // @备注：如果当前视图是触发布局更新的事件源，则需要设置参考了当前视图的视图的更新计数器
    if (self.layoutUpdateCount==0) {
        [self aktSetLayoutUpdateCount];
        screenRotating = mAKT_EQ(old.size.width, new.size.height) && mAKT_EQ(old.size.height, new.size.width);
    }
    // 更新布局链节点布局
    [self aktUpdateLayoutChainNode];
}

/**
 *  系统 Dealloc 方法
 */
- (void)myDealloc {
    // 移除布局信息\布局参考引用信息
    if(self.attributeRef) {
        free(self.attributeRef);
    }
    AKTWeakContainer *myContainer = self.aktContainer;
    for (AKTWeakContainer *container in self.layoutChain) {
        [container.weakView.viewsReferenced removeObject:myContainer];
    }
    for (AKTWeakContainer *container in self.viewsReferenced) {
        [container.weakView.layoutChain removeObject:myContainer];
    }
    //    mAKT_Log(@"%@ _dealloc count:%d",self.aktName, i);
    [self myDealloc];
}
@end

@implementation AKTWeakContainer

@end