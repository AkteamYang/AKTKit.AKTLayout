//
//  UIView+QuickLayout.m
//  AKTeamUikitExtension
//
//  Our goal is to be the best framework for automatic layout
//  Your support will help AKTLayout rising, welcome to provide code support, suggest improvements   to AKTLayout or lit a Star for us
//  https://github.com/AkteamYang/AKTKit.AKTLayout
//  AKTLayout version 1.2.0
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
char const kAktDidLayoutTarget;
char const kAktDidLayoutSelector;
char const kAktDidLayoutComplete;

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
 * 添加AKTLayout布局属性，你可以为视图添加多种布局项（top/left/bottom/width/whRatio...），当你添加布局项时你不用关心添加的顺序，语法非常容易理解和编写，为了达到要求我们进行了很多内部转换，但是仍然保持了高性能表现，我已经很久不用系统的自动布局，因为在复杂的视图关系中，它的性能表现实在过于糟糕，为了达到性能要求，必须要手写并计算布局代码，这是一件令人乏味而耗费时间的事情，如果你正在被这些问题困扰，可以尝试一下性能优异的AKTLayout！！！
 *   https://github.com/AkteamYang/AKTKit.AKTLayout
 *   我们的目标是成为最好的自动布局框架
 *   你的支持将有助于AKTLayout不断提升，欢迎为AKTLayout提供代码支持、改进建议或者为我们点上一颗Star
 */
- (void)aktLayout:(void(^)(AKTLayoutShellAttribute *layout))layout
{
    // 如果layout不存在，移除原有的布局配置信息
    void(^removeLastAttribute)(BOOL needFree) = ^(BOOL needFree){
        // Change view's attributRef
        AKTLayoutAttributeRef pt = self.attributeRef;
        if (pt) {
            aktLayoutAttributeDealloc(pt, needFree);
        }
        // 移除先前的AKTLayout布局设置关联信息，并更新当前信息
        for (AKTWeakContainer *container in self.viewsReferenced) {
            [container.weakView.layoutChain removeObject:self.aktContainer];
        }
        [self.viewsReferenced removeAllObjects];
    };
    // 检测视图是否有效，没有父视图的view是无效的
    if (!self.superview) {
        NSString *description = [NSString stringWithFormat:@"> %@: Your view should have a superview.\n> 当前视图尚未添加到父视图", self.aktName];
        NSString *sugget = [NSString stringWithFormat:@"> Before add layout, firstly adding a view to a parent view. For more details, please refer to the error message described in the document. 添加布局前先将视图添加到父视图，详情请参考错误信息描述文档"];
        __aktErrorReporter(101, description, sugget);
        return;
    }
    // 清除布局信息
    if(!layout){
        removeLastAttribute(YES);
        self.attributeRef = nil;
        return;
    }
    // Bug report: 如果A在布局时引用了B并触发了B布局的创建，由于创建布局时attribute是全局的，此时B应该先保存A的布局状态再开始B的布局。
    void *attributeRef_context = NULL;
    // 保存布局状态上下文。
    if(attributeRef_global && attributeRef_global->bindView != (__bridge const void *)(self)){
        attributeRef_context = attributeRef_global;
    }
    
    
    // 创建布局信息存储对象
    if (!self.attributeRef) {
        attributeRef_global = malloc(sizeof(AKTLayoutAttribute));
        if (!attributeRef_global) {
            NSString *description = [NSString stringWithFormat:@"> %@: Malloc AKTLayoutAttribute error!\n> 布局信息体内存开辟失败", self.aktName];
            NSString *sugget = [NSString stringWithFormat:@"> Please optimize memory allocation. For more details, please refer to the error message described in the document. 请优化内存分配，详情请参考错误信息描述文档"];
            __aktErrorReporter(303, description, sugget);
            // 恢复原来的布局上下文.
            attributeRef_global = attributeRef_context;
            return;
        }
    }else{
        removeLastAttribute(NO);
        attributeRef_global = self.attributeRef;
    }
    aktLayoutAttributeInit(self);
    
    
    // 获取布局信息并计算布局并设置frame
    layout(sharedShellAttribute());
    CGRect rect = calculateAttribute(attributeRef_global, NULL);
    // 添加动态布局信息获取Block（layoutInfoTag == CGFloat_MAX）
    self.attributeRef = attributeRef_global;
    self.frame = rect;
    // 已经布局完成回调
    __aktViewDidLayoutWithView(self);
    
    
    // 恢复原来的布局上下文.
    attributeRef_global = attributeRef_context;
    return;
}

/**
 *  设置视图需要刷新布局
 *  @备注：一般在更改了view的size需要立刻执行布局刷新时调用
 */
- (void)setAKTNeedRelayout {
    if (self.attributeRef) self.frame = calculateAttribute(self.attributeRef, NULL);
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
 *  已经完成布局
 *  @备注：当视图布局完成时会回调这个方法
 *
 *  @param target
 *  @param selector  selector的参数是当前的view (- (void)viewDidLayout:(UIView *)view)
 */
- (void)aktDidLayoutTarget:(id)target forSelector:(SEL)selector {
    if (!target || !selector) {
        return;
    }
    objc_setAssociatedObject(self, &kAktDidLayoutTarget, target, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, &kAktDidLayoutSelector, NSStringFromSelector(selector), OBJC_ASSOCIATION_COPY);
}

/**
 *  已经完成布局
 *
 *  @param complete
 */
- (void)aktDidLayoutWithComplete:(void(^)(UIView *view))complete {
    objc_setAssociatedObject(self, &kAktDidLayoutComplete, complete, OBJC_ASSOCIATION_COPY);
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
 *  @备注：当支持旋转屏幕动画时，仅仅会导致旋转屏幕时视图布局速度将降低！一般情况下默认开启
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
