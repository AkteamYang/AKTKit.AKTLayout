//
//  UIImage+AKT.h
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/10.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AKT)
/*
 * Create image from color.
 * 从颜色创建图片
 * @color: The color of the image.
 * @color: 图片的颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/*
 * The image trimming to the specified dimensions
 * 将图片修剪为指定尺寸
 * @img: original image
 * @img: 原始图片
 * @size: destinated size
 * @size: 目标size
 * @complete: complete invoke
 * @complete: 完成回调
 */
+ (void)imageCutImage:(UIImage *)img toSize:(CGSize)size complete:(void(^)(UIImage *result))complete;
@end
