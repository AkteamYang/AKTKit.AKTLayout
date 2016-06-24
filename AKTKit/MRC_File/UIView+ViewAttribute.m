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
extern char const kAktDidLayoutTarget;
extern char const kAktDidLayoutSelector;
extern char const kAktDidLayoutComplete;
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
- (NSMutableSet *)layoutChain {
    NSMutableSet *set = objc_getAssociatedObject(self, kLayoutChain);
    if (!set) {
        set = [NSMutableSet set];
        objc_setAssociatedObject(self, kLayoutChain, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return set;
}

/**
 *  当前视图所参考的视图的数组
 *
 *  @return 当前视图所参考的视图的数组
 */
- (NSMutableSet *)viewsReferenced {
    NSMutableSet *set = objc_getAssociatedObject(self, kViewsReferenced);
    if (!set) {
        set = [NSMutableSet set];
        objc_setAssociatedObject(self, kViewsReferenced, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return set;
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
    objc_setAssociatedObject(self, kAttributeRef, [NSValue valueWithPointer:attributeRef], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    // 刷新子节点布局
    NSArray *temp = self.layoutChain.allObjects;
    for (int i = 0; i<temp.count; i++) {
        AKTWeakContainer *container = temp[i];
        UIView *bindView = container.weakView;
        // 如果bindView的布局更新计数器大于最小刷新阈值，则暂时不必计算布局更新
        NSInteger layoutUpdateCount = bindView.layoutUpdateCount;
        //        NSLog(@"%@",bindView.aktName);
        
        if (layoutUpdateCount>1) {
            bindView.layoutUpdateCount = layoutUpdateCount-1;
            continue;
        }
        // 是否需要同步运算（需要动画时、需要旋转时 或者 视图是UITableView 、 UICollectionView）
        if (willCommitAnimation || (screenRotatingAnimationSupport && screenRotating) || [bindView isKindOfClass:[UITableView class]] || [bindView isKindOfClass:[UICollectionView class]]) {
            CGRect rect = calculateAttribute(bindView.attributeRef, self);
            [bindView setFrame:rect];
            __aktViewDidLayoutWithView(bindView);// 通知target当前视图布局完成
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect rect = calculateAttribute(bindView.attributeRef, self);
                [bindView setNewFrame:rect];
                __aktViewDidLayoutWithView(bindView);// 通知target当前视图布局完成
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
 *  @param trackArray 用于纪录当前参照路径，识别循环参照
 *  @备注：包含所有布局建立在当前视图基础上的视图（直接或间接参考了当前视图的视图）
 */
- (void)aktSetLayoutUpdateCountWithPath:(NSMutableArray *)pathArray {
    for(AKTWeakContainer *container in self.layoutChain) {
        UIView *view = container.weakView;
        view.layoutUpdateCount++;
        // 当nodeView的视图刷新次数大于1时不必再向下迭代增加子节点的布局更新次数，因为在必要时nodeView只刷新一次
        //        NSLog(@"%@:  count: %d",view.aktName, view.layoutUpdateCount);
        if (view.layoutUpdateCount>1) {
            // 检测循环参照
            if ([pathArray containsObject:view]) {
                __aktPrintCycleReference(pathArray, view);
            }
            continue;
        }
        [pathArray addObject:view];
        // NodeView首次设置刷新时，为子节点添加刷新计数
        [container.weakView aktSetLayoutUpdateCountWithPath:pathArray];
        [pathArray removeLastObject];
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
    BOOL frameNeedChange = [self setViewWithFrame:frame];
    if(self.layoutChain.count<=0) return;
    
    
    // 设置相关视图的布局更新计数器
    // @备注：如果当前视图是触发布局更新的事件源，则需要设置参考了当前视图的视图的更新计数器
    BOOL isDriverView = NO;
    if (self.layoutUpdateCount==0) {
        if(!frameNeedChange) return;
//        NSLog(@"%@ %p tag：%ld",self.aktName, self, self.tag);
        isDriverView = YES;
        self.layoutUpdateCount = 1;// @备注：为符合整体处理逻辑，事件源视图布局计数加一，等待相关布局更新完成后减一
        NSMutableArray *pathArr = __aktGetPathArray();
        [pathArr addObject:self];
        [self aktSetLayoutUpdateCountWithPath:pathArr];
        __aktGetPathArray(); // @备注：路径跟踪数组清空
        screenRotating = (mAKT_EQ(old.size.width, mAKT_SCREENWITTH) || mAKT_EQ(old.size.width, mAKT_SCREENHEIGHT)) && mAKT_EQ(old.size.width, new.size.height) && mAKT_EQ(old.size.height, new.size.width);
    }
    // 更新布局链节点布局
    [self aktUpdateLayoutChainNode];
    if(isDriverView) {
        self.layoutUpdateCount = 0;
    }
}

/**
 *  系统 Dealloc 方法
 */
- (void)myDealloc {
    // 移除布局信息\布局参考引用信息
    if(self.attributeRef) {
        AKTLayoutAttributeRef pt = self.attributeRef;
        aktLayoutAttributeDealloc(pt, true);
    }
    AKTWeakContainer *myContainer = self.aktContainer;
    for (AKTWeakContainer *container in self.layoutChain) {
        [container.weakView.viewsReferenced removeObject:myContainer];
        AKTLayoutAttributeRef ref = container.weakView.attributeRef;
        if (ref) {
            ref->validLayoutAttributeInfo = false;
        }
    }
    for (AKTWeakContainer *container in self.viewsReferenced) {
        [container.weakView.layoutChain removeObject:myContainer];
    }
//        mAKT_Log(@"%@ _dealloc",self.aktName);
    [self myDealloc];
}

#pragma mark - function implementations
//|---------------------------------------------------------
/**
 *  获取跟踪数据
 *
 *  @return
 */
NSMutableArray *__aktGetPathArray() {
    static id pathArrObj = nil;
    if(!pathArrObj){
        pathArrObj = [NSMutableArray array];
        [pathArrObj retain];
    }
    NSMutableArray *pathArr = pathArrObj;
    [pathArr removeAllObjects];
    return pathArr;
}

/**
 *  打印循环参照路径
 *
 *  @param view
 */
void __aktPrintCycleReference(NSArray *pathArray, UIView *lastView) {
    NSMutableString *description = [NSMutableString string];
    [description appendString:@"> AKTLayout cycle reference happened！\n> AKTLayout 发生循环参照！\n> Layout reference path: "];
    for (UIView *view in pathArray) {
        [description appendString:[NSString stringWithFormat:@"[%@] -> ", view.aktName]];
    }
    [description appendString:[NSString stringWithFormat:@"[%@]", lastView.aktName]];
    NSString *suggest = @"> Please check the reference settings of these views. 请检查这些视图的参照设置";
    __aktErrorReporter(100, description, suggest);
}

/**
 *  AKTLayout standard log
 *
 *  @param errorCode
 *  @param description
 *  @param suggest
 */
void __aktErrorReporter(int errorCode, NSString *description, NSString *suggest) {
    NSString *str = [NSString stringWithFormat:@"\n> AKTLayout error: %d\n%@\n%@", errorCode, description, suggest];
    mAKT_Log(@"%@", str);
}

/**
 *  给视图设置frame
 *
 *  @param frame
 */
- (BOOL)setViewWithFrame:(CGRect)frame {
    CGRect old = self.frame;
    CGRect new = frame;
    if(frame.origin.x>=FLT_MAX-1){
        // 这个frame设置仅仅为了通知当前view的相关view进行异步布局运算，而不必设置frame
        nil;
    }else{
        if (mAKT_EQ(old.size.width, new.size.width) && mAKT_EQ(old.size.height, new.size.height) && mAKT_EQ(old.origin.x, new.origin.x) && mAKT_EQ(old.origin.y, new.origin.y)) {
            return NO;
        }
        [self setNewFrame:frame];
    }
    return YES;
}

/**
 *  已经布局完成回调
 *
 *  @param view 当前视图
 */
void __aktViewDidLayoutWithView(UIView *view) {
    void(^complete)(UIView *view) = objc_getAssociatedObject(view, &kAktDidLayoutComplete);
    if (complete) {
        complete(view);
    }
    id target = objc_getAssociatedObject(view, &kAktDidLayoutTarget);
    if (!target) {
        return;
    }
    NSString *selectorStr = objc_getAssociatedObject(view, &kAktDidLayoutSelector);
    if (!selectorStr || !view.superview) {
        return;
    }
    [target performSelector:NSSelectorFromString(selectorStr) withObject:view];
}
@end

@implementation AKTWeakContainer

@end