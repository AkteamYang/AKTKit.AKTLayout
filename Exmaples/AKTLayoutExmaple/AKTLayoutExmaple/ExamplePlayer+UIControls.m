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
        AKTWeakView(weakContainer, self.container);
        AKTWeakView(weakList, self.list);
        AKTWeakView(weakPlay, self.play);
        [self.play aktLayout:^(AKTLayoutShellAttribute *layout) {
            [layout addDynamicLayoutInCondition:^BOOL{
                return weakContainer.height>55;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                [weakPlay setImage:mAKT_Image_Origin(@"CH_PlayBig") forState:(UIControlStateNormal)];
                [weakPlay setImage:mAKT_Image_Origin(@"CH_PauseBig") forState:(UIControlStateSelected)];

                // Delta between state.
                CGFloat deltaCenterX = mAKT_SCREENWITTH/2-(mAKT_SCREENWITTH-(19+25+16+15));
                CGFloat deltaContainerHeight = mAKT_SCREENHEIGHT-64-45-55;
                CGFloat deltaHeight = 65-30;
                CGFloat deltaBottom = (mAKT_SCREENHEIGHT-64-45-25)-(55-(55-30)/2);
                
                dynamicLayout.height.width.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(deltaHeight/deltaContainerHeight).offset(30);
                dynamicLayout.centerX.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(deltaCenterX/deltaContainerHeight).offset(mAKT_SCREENWITTH-(19+25+16+15));
                dynamicLayout.bottom.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(deltaBottom/deltaContainerHeight).offset(55-(55-30)/2);
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return weakContainer.height<=55;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                [weakPlay setImage:mAKT_Image_Origin(@"CH_PlayLittle") forState:(UIControlStateNormal)];
                [weakPlay setImage:mAKT_Image_Origin(@"CH_PauseBig") forState:(UIControlStateSelected)];

                dynamicLayout.width.equalTo(akt_value(30));
                dynamicLayout.height.equalTo(weakContainer.akt_height).offset(-(55-30));
                dynamicLayout.centerY.equalTo(weakContainer.akt_centerY);
                dynamicLayout.right.equalTo(weakList.akt_left).offset(-16);
            }];
        }];
    }
}

@end
