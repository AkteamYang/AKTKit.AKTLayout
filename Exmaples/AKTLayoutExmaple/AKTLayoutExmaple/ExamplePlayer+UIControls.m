//
//  ExamplePlayer+UIControls.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/6/21.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExamplePlayer+UIControls.h"
#import "ExamplePlayer.h"

@implementation ExamplePlayer (UIControls)
- (UIImageView *)coverLittle {
    if (!_coverLittle) {
        _coverLittle = [[UIImageView alloc]initWithImage:mAKT_Image(@"Cover")];
        [self.container addSubview:_container];
        AKTWeakOject(weakContainer, self.container);
        [_coverLittle aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.width.height.equalTo(akt_value(55));
            layout.bottom.equalTo(weakContainer.akt_bottom);
            [layout addDynamicLayoutInCondition:^BOOL{
                return weakContainer.height<205;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.left.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(-(55.f/150));
            }];
        }];
    }
    return _coverLittle;
}
@end
