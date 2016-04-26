//
//  UIImage+AKT.m
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/10.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import "UIImage+AKT.h"

@implementation UIImage (AKT)
/*
 * Create image from color.
 * 从颜色创建图片
 * @color: The color of the image.
 * @color: 图片的颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContext(CGSizeMake(10, 10));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/*
 * The image trimming to the specified dimensions
 * 将图片修剪为指定尺寸
 * @img: original image
 * @img: 原始图片
 * @size: destinated size unit：pixel
 * @size: 目标size 单位：像素
 * @complete: complete invoke
 * @complete: 完成回调
 */
+ (void)imageCutImage:(UIImage *)img toSize:(CGSize)size complete:(void(^)(UIImage *result))complete {
//    aktDispatcher_global_add(^(AKTAsyncTaskInfo *taskInfo) {
//        [taskInfo setTaskOperation:^id{
//            return nil;
//        }];
//    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *newImage;
        CGSize imgSize = img.size;
        CGPoint drawPoint;
        CGSize scaledSize;
        if (imgSize.width/imgSize.height < size.width/size.height) {//scale with width
            scaledSize = CGSizeMake(size.width, imgSize.height/(imgSize.width/size.width));
            drawPoint.x = 0;
            drawPoint.y = - (scaledSize.height-size.height)/2;
        }else{//scale with height
            scaledSize = CGSizeMake(imgSize.width/(imgSize.height/size.height), size.height);
            drawPoint.y = 0;
            drawPoint.x = - (scaledSize.width-size.width)/2;
        }
        UIGraphicsBeginImageContext(size);
        [img drawInRect:CGRectMake(drawPoint.x, drawPoint.y, scaledSize.width, scaledSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(newImage);
            }
        });
    });
}
@end
