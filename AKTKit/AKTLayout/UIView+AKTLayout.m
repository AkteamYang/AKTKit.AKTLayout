//
//  UIView+QuickLayout.m
//  AKTeamUikitExtension
//
//  Created by YaHaoo on 15/9/8.
//  Copyright (c) 2015年 CoolHear. All rights reserved.
//

#import "UIView+AKTLayout.h"
#import "AKTPublic.h"
#import "UIView+ViewAttribute.h"
#import <objc/runtime.h>

//--------------------Structs statement, globle variables...--------------------
static char * const kLastFrame = "kLastFrame";
static char * const kAktName = "aktName";
AKTLayoutAttributeRef attributeRef_global = NULL;
BOOL willCommitAnimation = NO;
extern BOOL screenRotatingAnimationSupport;
//-------------------- E.n.d -------------------->Structs statement & globle variables

@interface UIView()
@end

@implementation UIView (AKTLayout)
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

#pragma mark - layout methods
//|---------------------------------------------------------
- (AKTReference)akt_top {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Top};
    return ref;
}

- (AKTReference)akt_left {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Left};
    return ref;
}

- (AKTReference)akt_bottom {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Bottom};
    return ref;
}

- (AKTReference)akt_right {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Right};
    return ref;
}

- (AKTReference)akt_width {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Width};
    return ref;
}

- (AKTReference)akt_height {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Height};
    return ref;
}

- (AKTReference)akt_whRatio {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_WHRatio};
    return ref;
}

- (AKTReference)akt_centerX {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_CenterX};
    return ref;
}

- (AKTReference)akt_centerY {
    AKTReference ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_CenterY};
    return ref;
}

#pragma mark - AKTLayout
//|---------------------------------------------------------
/*
 * Configure layout attributes. It's a AKTLayout method and you can add layout items such as: top/left/bottom/width/whRatio... into currentView. When you add items you don't need to care about the order of these items. The syntax is very easy to write and understand. In order to meet the requirements, we did a lot in the internal processing. But the performance is still outstanding. I have already no longer use autolayout. Because autolayout has a bad performance especially when the view is complex.In order to guarantee the performance we can handwrite frame code. But it's a boring thing and a waste of time. What should I do? Please try AKTLayout！！！
 * Notice！If one view call the method for many times the last call may override the previous one. Including layout attribute configuration and view's adapting properties.
 */
- (void)aktLayout:(void(^)(AKTLayoutShellAttribute *layout))layout
{
    // Whether the view is validate
    if (!self.superview) {
        mAKT_Log(@"%@: %@\nYour view or the referenceview should has a superview",[self class], self.aktName);
        return;
    }
    // Set layout items and reference object for the layout attribute
    // Bug report: 如果A在布局时引用了B并触发了B布局的创建，由于创建布局时attribute是全局的，此时B应该先保存A的布局状态再开始B的布局。
    void *attributeRef_context = NULL;
    // 保存布局状态上下文。
    if(attributeRef_global && attributeRef_global->bindView != (__bridge const void *)(self)){
        attributeRef_context = attributeRef_global;
    }
    attributeRef_global = malloc(sizeof(AKTLayoutAttribute));
    if (!attributeRef_global) {
        mAKT_Log(@"%@: %@\nMalloc AKTLayoutAttribute error!",[self class], self.aktName);
        // 恢复原来的布局上下文.
        attributeRef_global = attributeRef_context;
        return;
    }
    aktLayoutAttributeInit(self);
    // Set the view what the attribute effect on to the attribute. We call the view the bindView. Before setting the bindView we need initialize the view's adapting properties.
    if (!(self.adaptiveHeight || self.adaptiveWidth)) {
        self.adaptiveWidth = @(YES);
        self.adaptiveHeight = @(YES);
    }
    if (layout) {
        layout([AKTLayoutShellAttribute sharedInstance]);
    }else{
        // 恢复原来的布局上下文.
        attributeRef_global = attributeRef_context;
        return;
    }
    // Change view's attributRef
    AKTLayoutAttributeRef pt = self.attributeRef;
    if (pt) {
        CFRelease(pt->bindView);
        free(pt);
    }
    // Remove layout chain in referened view
    for (UIView *referenceView in self.viewsReferenced) {
        [referenceView.layoutChain removeObject:self];
    }
    [self.viewsReferenced removeAllObjects];
    self.attributeRef = attributeRef_global;
    // Calculate layout with layout attriute.
    CGRect rect = calculateAttribute(attributeRef_global);
    attributeRef_global->check = true;
    // Set frame
    self.frame = rect;
    // 是否退出
    // 恢复原来的布局上下文.
    attributeRef_global = attributeRef_context;
    return;
}

/*
 * The method："aktLayoutUpdate" will be called when the view's frame size changed. We can insert our subview layout code into the method, so that the UI can adaptive change
 */
- (void)setLastFrame:(CGRect)lastFrame
{
    objc_setAssociatedObject(self, kLastFrame, [NSValue valueWithCGRect:lastFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)lastFrame
{
    NSValue *value = objc_getAssociatedObject(self, kLastFrame);
    return [value CGRectValue];
}

- (void)layoutSubviews {
#if AKTLyoutVersion < 12
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    int widthOld = self.lastFrame.size.width;
    int heightOld = self.lastFrame.size.height;
    if (width == widthOld && height == heightOld) {
        nil;
    }else{
        self.lastFrame = self.frame;
        [self aktLayoutUpdate];
    }
#else
    [self performSelector:@selector(aktLayoutUpdate)];
#endif
}

- (void)aktLayoutUpdate
{
    
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

/**
 *  添加AKTLyout动画
 *
 *  @param animation 动画代码
 */
+ (void)aktAnimation:(void(^)())animation {
    willCommitAnimation = YES;
    if (animation) {
        animation();
    }
    willCommitAnimation = NO;
}

/**
 *  是否支持旋转屏幕动画
 *  @备注：当支持旋转屏幕动画时，旋转屏幕视图布局速度将降低！一般情况下默认开启
 *
 *  @param support
 */
+ (void)aktScreenRotatingAnimationSupport:(BOOL)support {
    screenRotatingAnimationSupport = support;
}
#pragma mark - distribute
//|---------------------------------------------------------
/*
 * 将给定的view分布放置
 * @source：view 数组
 * @rect：最终分布的矩形区域，
 * @lines: 行数
 * @columns: 列数
 * @itemHandler: 每放置好一个view，将会调用一次block
 * @note：view放置在行和列的交叉点
 */
- (void)aktLayoutDistributeSource:(NSArray<UIView *> *)source distributeRect:(CGRect)rect lines:(NSInteger)lines columns:(NSInteger)columns itemHandler:(void(^)(UIView *item))itemHandler {
    CGFloat x, y, width, height, spaceW, spaceH;
    x      = rect.origin.x;
    y      = rect.origin.y;
    width  = rect.size.width;
    height = rect.size.height;
    spaceW = width/(columns-1);
    spaceH = lines<=1? 0:height/(lines-1);
    for (int i = 0; i<source.count; i++) {
        UIView *v = source[i];
        [self addSubview:v];
        int cLine, cColumn;
        cLine     = i/columns;
        cColumn   = i%columns;
        v.center  = CGPointMake(x+cColumn*spaceW, y+cLine*spaceH);
        if (itemHandler) {
            itemHandler(v);
        }
    }
}
@end
