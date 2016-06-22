//
//  ExamplePlayer+UIControls.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/6/21.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExamplePlayer+UIControls.h"
#import "AKTKit.h"


@implementation ExamplePlayer (UIControls)
#pragma mark - view settings
- (void)initUIForContainer {
    [self coverLittleMake];
    [self listMake];
    [self playMake];
}

#pragma mark - UICreations
- (void)coverLittleMake {
    if (!self.coverLittle) {
        self.coverLittle = [[UIImageView alloc]initWithImage:mAKT_Image(@"Cover")];
        [self.container addSubview:self.coverLittle];
        AKTWeakView(weakContainer, self.container);
        [self.coverLittle aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.bottom.equalTo(weakContainer.akt_bottom);
            layout.width.equalTo(akt_value(55));
            [layout addDynamicLayoutInCondition:^BOOL{
                return weakContainer.height>55;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.height.equalTo(akt_value(55));
                dynamicLayout.left.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(-(55.f/150));
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return weakContainer.height<=55;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.left.top.equalTo(weakContainer.akt_left);
            }];
        }];
    }
}

- (void)listMake {
    if (!self.list) {
        self.list = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.container addSubview:self.list];
        UIImage *img = mAKT_Image_Origin(@"CH_ListLittle");
        [self.list setImage:img forState:(UIControlStateNormal)];
        AKTWeakView(weakContainer, self.container);
        [self.list aktLayout:^(AKTLayoutShellAttribute *layout) {
            [layout addDynamicLayoutInCondition:^BOOL{
                return weakContainer.height<=55 && weakContainer.height>img.size.height;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.size.equalTo(akt_size(img.size.width, img.size.height));
                dynamicLayout.right.equalTo(weakContainer.akt_right).offset(-19);
                dynamicLayout.centerY.equalTo(weakContainer.akt_centerY);
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return weakContainer.height<img.size.height;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.width.equalTo(akt_value(img.size.width));
                dynamicLayout.right.equalTo(weakContainer.akt_right).offset(-19);
                dynamicLayout.top.bottom.equalTo(akt_view(weakContainer));
            }];
        }];
    }
}

- (void)playMake {
    if (!self.play) {
        self.play = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.container addSubview:self.play];
        UIImage *img = mAKT_Image_Origin(@"CH_PlayBig");
        [self.play setImage:img forState:(UIControlStateNormal)];
        [self.play setImage:mAKT_Image_Origin(@"CH_PauseBig") forState:(UIControlStateSelected)];
        AKTWeakView(weakContainer, self.container);
        [self.play aktLayout:^(AKTLayoutShellAttribute *layout) {
            __block BOOL flag = YES;
            layout.top.left.equalTo(akt_view(weakContainer));
            [layout addDynamicLayoutInCondition:^BOOL{
                return flag;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                flag = !flag;
                dynamicLayout.whRatio.equalTo(akt_value(1));
                dynamicLayout.height.equalTo(akt_value(30)).multiple((weakContainer.height-55)/(mAKT_SCREENHEIGHT-64)).offset(35);
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return !flag;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                flag = !flag;
                dynamicLayout.whRatio.equalTo(akt_value(1));
                dynamicLayout.height.equalTo(akt_value(30)).multiple((weakContainer.height-55)/(mAKT_SCREENHEIGHT-64)).offset(35);
            }];
        }];
    }
}

@end
