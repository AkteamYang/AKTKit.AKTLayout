//
//  AKTImagePicker.m
//  Coolhear 3D Player
//
//  Created by YaHaoo on 16/4/11.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import "AKTImagePicker.h"
#import "AKTPublic.h"
#import "UIImage+AKT.h"

@interface AKTImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *vc;
@end
@implementation AKTImagePicker
#pragma mark - life cycle
//|---------------------------------------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
#pragma mark - view settings
//|---------------------------------------------------------
- (void)chooseFromLibrary {
    [self.vc setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    self.vc.allowsEditing = self.enableEditing;
    [mAKT_APPDELEGATE.window.rootViewController presentViewController:self.vc animated:YES completion:nil];
}
- (void)chooseFromCamera {
    [self.vc setSourceType:(UIImagePickerControllerSourceTypeCamera)];
    self.vc.allowsEditing = self.enableEditing;
    [mAKT_APPDELEGATE.window.rootViewController presentViewController:self.vc animated:YES completion:nil];
}
#pragma mark - model settings
//|---------------------------------------------------------
- (void)initialize {
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    self.vc = ipc;
    ipc.delegate = self;
    self.size = CGSizeMake(FLT_MAX, FLT_MAX);
}
#pragma mark - delegate
//|---------------------------------------------------------
/*
 * Finish choosing a image.
 * 图片选择完成
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    mAKT_Log(@"%@",info);
    if (self.result) {
        UIImage *img = self.enableEditing? info[UIImagePickerControllerEditedImage]:info[UIImagePickerControllerOriginalImage];
        if (self.size.width<FLT_MAX) {
            [UIImage imageCutImage:img toSize:(self.size) complete:^(UIImage *result) {
                self.result(NO, result);
                [picker dismissViewControllerAnimated:YES completion:nil];
            }];
            return;
        }
        self.result(NO, img);
    }
}
/*
 * Cancel choose image.
 * 取消图片选择
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if (self.result) {
        self.result(YES, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
