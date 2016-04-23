//
//  UIView+QuickLayout.m
//  AKTeamUikitExtension
//
//  Created by YaHaoo on 15/9/8.
//  Copyright (c) 2015年 CoolHear. All rights reserved.
//

#import "UIView+AKTLayout.h"
#import "AKTPublic.h"
#import <objc/runtime.h>

//--------------------Structs statement, globle variables...--------------------
static char * const kLastFrame = "kLastFrame";
AKTLayoutAttributeRef attributeRef_global = NULL;
//-------------------- E.n.d -------------------->Structs statement & globle variables

@interface UIView()
@end

@implementation UIView (AKTLayout)
#pragma mark - layout methods
- (AKTRefence)akt_top {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Top};
    return ref;
}

- (AKTRefence)akt_left {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Left};
    return ref;
}

- (AKTRefence)akt_bottom {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Bottom};
    return ref;
}

- (AKTRefence)akt_right {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Right};
    return ref;
}

- (AKTRefence)akt_width {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Width};
    return ref;
}

- (AKTRefence)akt_height {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_Height};
    return ref;
}

- (AKTRefence)akt_whRatio {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_WHRatio};
    return ref;
}

- (AKTRefence)akt_centerX {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_CenterX};
    return ref;
}

- (AKTRefence)akt_centerY {
    AKTRefence ref;
    aktReferenceInit(&ref);
    ref.referenceValidate  = true;
    ref.referenceType      = AKTRefenceType_ViewAttribute;
    ref.referenceAttribute = (AKTViewAttributeInfo){(__bridge void *)(self), AKTAttributeItemType_CenterY};
    return ref;
}

/*
 * Configure layout attributes. It's a AKTLayout method and you can add layout items such as: top/left/bottom/width/whRatio... into currentView. When you add items you don't need to care about the order of these items. The syntax is very easy to write and understand. In order to meet the requirements, we did a lot in the internal processing. But the performance is still outstanding. I have already no longer use autolayout. Because autolayout has a bad performance especially when the view is complex.In order to guarantee the performance we can handwrite frame code. But it's a boring thing and a waste of time. What should I do? Please try AKTLayout！！！
 * Notice！If one view call the method for many times the last call may override the previous one. Including layout attribute configuration and view's adapting properties.
 */
- (void)aktLayout:(void(^)(AKTLayoutShellAttribute *layout))layout
{
    BOOL (^block)() = ^BOOL{
        // Whether the view is validate
        if (!self.superview) {
            mAKT_Log(@"%@: %@\nYour view or the referenceview should has a superview",[self class], self.aktName);
            return NO;
        }
        // Set layout items and reference object for the layout attribute
        attributeRef_global = NULL;
        attributeRef_global = malloc(sizeof(AKTLayoutAttribute));
        if (!attributeRef_global) {
            mAKT_Log(@"%@: %@\nMalloc AKTLayoutAttribute error!",[self class], self.aktName);
            return NO;
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
            return NO;
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
//         更新布局计数器
//        self.layoutCount = self.layoutChain.count;
        // Set frame
        self.frame = rect;
        // 是否退出
        return NO;
    };
    block();
//    // Whether cunrrent view is setting layout.
//    if (self.layoutCount>=self.layoutChain.count) {
//        block();
//        return;
//    }
//    // 停止新的布局更新（包括自身和子节点的布局更新）
//    self.layoutActive = NO;
//    [self.layoutComplete addObject:block];
}

#pragma mark - update frame
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
}

- (void)aktLayoutUpdate
{

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
