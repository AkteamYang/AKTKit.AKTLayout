//
//  AKTPublic.c
//  Pursue
//
//  Created by YaHaoo on 16/3/19.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#include "AKTPublic.h"
/*
 * Safty check whether "a" is equal to "b". Support: int float or double
 */
bool aktValueEqual(double a, double b) {
    double delta = ABS(a-b);
    if (delta>1) {
        return false;
    }else{
        delta *= 1e4;
        if (delta>1) {
            return false;
        }else{
            return true;
        }
    }
}

UIImage * aktNoBlendImage(UIImage *image, UIColor *backgroundColor) {
    UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
    [backgroundColor setFill];
    CGRect rec = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, rec);
    [image drawInRect:rec];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}

/*
 * Random color
 */
UIColor *aktRandomColor(CGFloat alpha) {
    int r, g, b;
    while (1) {
        r = arc4random()%255;
        g = arc4random()%255;
        b = arc4random()%255;
        if (ABS(g-r)+ABS(b-r)>40) {
            break;
        }
    }
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:alpha];
}

/**
 *  Round corner
 *
 *  @param view
 *  @param cornerRadius
 */
void addmask(UIView *view, CGFloat cornerRadius) {
    CAShapeLayer *maskLayer = AKTAutorelease([[CAShapeLayer alloc]init]);
    maskLayer.frame = view.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:cornerRadius];
    maskLayer.path = [path CGPath];
    view.layer.mask = maskLayer;
}

/**
 *  获取像素级尺寸
 *
 *  @param value
 *
 *  @return
 */
CGFloat aktPicFloat(CGFloat value) {
    static CGFloat unit;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unit = 1/[UIScreen mainScreen].scale;
    });
    CGFloat decimalValue = value - (NSInteger)value;
    value = (NSInteger)value+unit*(NSInteger)(decimalValue/unit+1);
    return value;
}

CGRect aktPixRect(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(aktPicFloat(x), aktPicFloat(y), aktPicFloat(width), aktPicFloat(height));
}

CGSize aktPixSize(CGFloat width, CGFloat height) {
    return CGSizeMake(aktPicFloat(width), aktPicFloat(height));
}