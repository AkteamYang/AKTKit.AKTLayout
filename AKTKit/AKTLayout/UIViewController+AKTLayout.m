//
//  UIViewController+AKTLayout.m
//  Aceband
//
//  Created by YaHaoo on 16/4/28.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "UIViewController+AKTLayout.h"
// import-<frameworks.h>
#import <objc/runtime.h>
// import-"models.h"
#import "NSObject+AKT.h"
#import "UIView+AKTLayout.h"
// import-"views & controllers.h"

//--------------------Structs statement, globle variables...--------------------
const char kVCEnterType;
typedef NS_ENUM(int, AKTVCEnterType) {
    AKTVCEnterType_Present,
    AKTVCEnterType_Push,
    AKTVCEnterType_Tab
};
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface UIViewController (AKTLayoutAid)
@property (assign, nonatomic) AKTVCEnterType enterType;
@end
@implementation UIViewController (AKTLayout)
#pragma mark - class method
//|---------------------------------------------------------
/**
 *  替换view controller方法
 */
+ (void)load {
    [UIViewController swizzleClass:[UIViewController class] fromMethod:@selector(viewDidAppear:) toMethod:@selector(aktViewDidAppear:)];
    [UIViewController swizzleClass:[UIViewController class] fromMethod:@selector(viewDidDisappear:) toMethod:@selector(aktViewDidDisappear:)];
}

#pragma mark - life cycle
//|---------------------------------------------------------
/**
 *  替换View did appear
 *
 *  @param animated 是否动画过度
 */
- (void)aktViewDidAppear:(BOOL)animated {
    // Get enter type.
    if (self.navigationController && [self.navigationController.viewControllers containsObject:self]) {
        self.enterType = AKTVCEnterType_Push;
    }else if (self.tabBarController && [self.tabBarController.viewControllers containsObject:self]) {
        self.enterType = AKTVCEnterType_Tab;
    }else if (self.presentingViewController){
        self.enterType = AKTVCEnterType_Present;
    }
    // View did appear.
    [self aktViewDidAppear:animated];
}

/**
 *  替换View did disappear
 *
 *  @param animated 是否动画过度
 */
- (void)aktViewDidDisappear:(BOOL)animated {
    switch (self.enterType) {
        case AKTVCEnterType_Present: {
            if (!self.presentingViewController) {
                [self.view aktDestroyFromSuperView];
            }
            break;
        }
        case AKTVCEnterType_Push: {
            if (![self.navigationController.viewControllers containsObject:self]) {
                [self.view aktDestroyFromSuperView];
            }
            break;
        }
        case AKTVCEnterType_Tab: {
            nil;
            break;
        }
    }
    // View did disappear
    [self aktViewDidDisappear:animated];
}

#pragma mark - property settings
//|---------------------------------------------------------
/**
 *  进入当前 view controller 的方式
 *
 *  @return 进入当前控制器方式
 */
- (AKTVCEnterType)enterType {
    id obj = objc_getAssociatedObject(self, &kVCEnterType);
    return obj? [obj intValue]:AKTVCEnterType_Present;
}

/**
 *  设置进入当前 view controller 的方式
 *
 *  @param enterType 进入方式
 */
- (void)setEnterType:(AKTVCEnterType)enterType {
    objc_setAssociatedObject(self, &kVCEnterType, @(enterType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
