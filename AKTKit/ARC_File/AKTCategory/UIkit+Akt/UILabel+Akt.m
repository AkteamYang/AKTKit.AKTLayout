//
//  UILabel+Akt.m
//  Pursue
//
//  Created by YaHaoo on 16/2/26.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//
// import-<frameworks.h>
// import-"models.h"
#import "NSObject+AKT.h"
// import-"views.h"
#import "UILabel+Akt.h"
#import "UIView+AKTLayout.h"
#import "AKTPublic.h"

//--------------------Structs statement, globle variables...--------------------
static char kAKTLabelMaxHeight;
static char kAKTLabelMaxWidth;
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@implementation UILabel (Akt)
#pragma mark - super method
//|---------------------------------------------------------
/*
 * Do something before initialization.
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Exchange "setText:" to "aktText:"
        [UILabel swizzleClass:[UILabel class] fromMethod:@selector(setText:) toMethod:@selector(aktText:)];
        [UILabel swizzleClass:[UILabel class] fromMethod:@selector(setText:) toMethod:@selector(setAKTNumberOfLines:)];
    });
}
#pragma mark - property settings
//|---------------------------------------------------------
- (void)setMaxWidth:(NSNumber *)maxWidth {
    if ([maxWidth floatValue]<0) {
        return;
    }
    objc_setAssociatedObject(self, &kAKTLabelMaxWidth, maxWidth, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)maxWidth {
    return objc_getAssociatedObject(self,  &kAKTLabelMaxWidth);
}

- (void)setMaxHeight:(NSNumber *)maxHeight {
    if ([maxHeight floatValue]<0) {
        return;
    }
    objc_setAssociatedObject(self, &kAKTLabelMaxHeight, maxHeight, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)maxHeight {
    return objc_getAssociatedObject(self,  &kAKTLabelMaxHeight);
}

/*
 * The method was exchaged to method "setText:" in the initialization of a label. So when we call "aktText:" in actually calling "setText:".
 */
- (void)aktText:(NSString *)text {
    // Set label's text
    [self aktText:text];
    
    // Setting all of them to NO means that the frame cann't change, just return.
    if (self.adaptiveHeight == nil && self.adaptiveWidth == nil) {
        return;
    }
    if (self.adaptiveWidth.boolValue == NO && self.adaptiveHeight.boolValue == NO) {
        return;
    }
    
    // If all of values of them are YES we'll set the view's height to single line height and adaptiveHeight to NO by default.
    if ([self.adaptiveWidth boolValue] == YES && [self.adaptiveHeight boolValue] == YES) {
        // 单行宽度自适应
        CGSize oldSize = self.frame.size;
        [self sizeToFit];
        if (self.maxWidth) {
            CGRect rec = self.frame;
            rec.size.width = self.maxWidth.floatValue;
            self.frame = rec;
        }
        // 如果size未发生变化则frame不必进行重计算
        if (mAKT_EQ(oldSize.width, self.width)&&mAKT_EQ(oldSize.height, self.height)) {
            return;
        }
    }else if ([self.adaptiveHeight boolValue]) {// 高度自适应
        CGRect rec = [text boundingRectWithSize:(CGSizeMake(self.width, 9999)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil];
        if(self.numberOfLines){// 设置了最大行数
            CGRect rec1 = [@" " boundingRectWithSize:(CGSizeMake(self.width, 9999)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil];
            CGRect rec2 = [@" \n " boundingRectWithSize:(CGSizeMake(self.width, 9999)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil];
            CGFloat height = rec1.size.height+(rec2.size.height-rec1.size.height)*(self.numberOfLines-1);
            self.height = rec.size.height>height? height:rec.size.height;
        }else{
            if (self.maxHeight) {
                self.height = self.maxHeight.floatValue<rec.size.height? self.maxHeight.floatValue:rec.size.height;
            }else{
                self.height = rec.size.height;
            }
        }
    }else if ([self.adaptiveWidth boolValue]) {
        CGRect rec = [text boundingRectWithSize:(CGSizeMake(9999, 9999)) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.font} context:nil];
        if (self.maxWidth) {
            self.width = self.maxWidth.floatValue<rec.size.width? self.maxWidth.floatValue:rec.size.width;
        }else{
            self.width = rec.size.width;
        }
    }
    // Update aktLayout
    [self setAKTNeedRelayout];
}

/**
 *  改变行数
 *  @备注 行数改变时自动重新布局
 *
 *  @param numberOfLines
 */
- (void)setAKTNumberOfLines:(NSInteger)numberOfLines {
    [self setAKTNumberOfLines:numberOfLines];
    self.text = self.text;
}


@end
