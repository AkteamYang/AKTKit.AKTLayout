//
//  ExamplePlayer+UIControls.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/6/21.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExamplePlayer+UIControls.h"
#import "AKTKit.h"

//--------------# Macro & Const #--------------
#define kExampleTint mAKT_Color_Color(80, 128, 215, 1)
//--------------# E.n.d #--------------#>Macro
@implementation ExamplePlayer (UIControls)
#pragma mark - view settings
- (void)initUIForContainer {
    // Create UI controls
    [self coverLittleMake];
    [self musicNameMakeAndLayout];
    [self artistMakeAndLayout];
    [self listMake];
    [self playMake];
    [self nextMusicMake];
    [self lastMusicMake];
    // Add layout.
    [self coverLittleLayout];
    [self playLayout];
    [self listLayout];
    [self nextMusicLayout];
    [self lastMusicLayout];
}

#pragma mark - UICreations
- (void)coverLittleMake {
    if (!self.coverLittle) {
        self.coverLittle = [[UIImageView alloc]initWithImage:mAKT_Image(@"Cover")];
        [self.container addSubview:self.coverLittle];
        self.coverLittle.aktName = @"coverLittle";
    }
}

- (void)musicNameMakeAndLayout {
    if (!self.musicName) {
        self.musicName = [UILabel new];
        [self.container addSubview:self.musicName];
        self.musicName.aktName = @"musicName";
        AKTWeakView(__cover, self.coverLittle);
        [self.musicName aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.top.equalTo(__cover.akt_top).offset(8);
            layout.left.equalTo(__cover.akt_right).offset(15);
        }];
        self.musicName.text = @"Over the Horizons";
        self.musicName.textColor = mAKT_Color_Text_52;
        self.musicName.font = mAKT_Font_18;
        self.musicName.numberOfLines = 1;
        self.musicName.maxWidth = @(mAKT_SCREENWITTH-55-15-19-25-16-30-10);
    }
}

- (void)artistMakeAndLayout {
    if (!self.artist) {
        self.artist = [UILabel new];
        [self.container addSubview:self.artist];
        self.artist.aktName = @"artist";
        AKTWeakView(__cover, self.coverLittle);
        AKTWeakView(__musicName, self.musicName);
        [self.artist aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.bottom.equalTo(__cover.akt_bottom).offset(-8);
            layout.left.equalTo(__musicName.akt_left);
//            layout.left.equalTo(__cover.akt_right).offset(15);
        }];
        self.artist.text = @"Sumsung";
        self.artist.textColor = mAKT_Color_Text_154;
        self.artist.font = mAKT_Font_14;
        self.artist.numberOfLines = 1;
        self.artist.maxWidth = @(mAKT_SCREENWITTH-55-15-19-25-16-30-10);
    }
}

- (void)listMake {
    if (!self.list) {
        self.list = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.container addSubview:self.list];
        UIImage *img = mAKT_Image(@"CH_ListLittle");
        [self.list setImage:img forState:(UIControlStateNormal)];
        self.list.aktName = @"listButton";
        [self.list setTintColor:kExampleTint];
        [self.list addTarget:self action:@selector(list:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)playMake {
    if (!self.play) {
        self.play = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.container addSubview:self.play];
        self.play.aktName = @"playButton";
        [self.play setTintColor:kExampleTint];
        [self.play addTarget:self action:@selector(play:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)nextMusicMake {
    if (!self.nextMusic) {
        self.nextMusic = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.container addSubview:self.nextMusic];
        self.nextMusic.aktName = @"nextMusicButton";
        [self.nextMusic setTintColor:kExampleTint];
        [self.nextMusic addTarget:self action:@selector(nextMusic:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)lastMusicMake {
    if (!self.lastMusic) {
        self.lastMusic = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.container addSubview:self.lastMusic];
        self.lastMusic.aktName = @"lastMusicButton";
        [self.lastMusic setTintColor:kExampleTint];
        [self.lastMusic addTarget:self action:@selector(lastMusic:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

#pragma mark - view settings
- (void)playLayout {
    // The view you'll reference to will be declared as weak reference.
    AKTWeakView(weakContainer, self.container);
    AKTWeakView(weakPlay, self.play);
    AKTWeakView(weakDrag, self.drag);
    AKTWeakView(weakCover, self.coverLittle);
    AKTWeakView(weakNext, self.nextMusic);
    AKTWeakView(weakLast, self.lastMusic);
    [self.play aktLayout:^(AKTLayoutShellAttribute *layout) {
        CGFloat deltaContainerHeight = mAKT_SCREENHEIGHT-64-weakDrag.height-55;
        // Add dynamic layout for different conditions.
        [layout addDynamicLayoutInCondition:^BOOL{
            // Set next and last music buttons show or hide. If the condition is satisfied(return Yes!), the block will be invoked every times before layout chaged.
            weakNext.alpha = weakLast.alpha = (weakContainer.height-55-200)/(deltaContainerHeight-200);
            return weakContainer.height>55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            [weakPlay setImage:mAKT_Image_Tint(@"CH_PlayBig") forState:(UIControlStateNormal)];
            [weakPlay setImage:mAKT_Image_Tint(@"CH_PauseBig") forState:(UIControlStateSelected)];
            // Value changed between the state of container view show and hide.
            CGFloat deltaCenterX = mAKT_SCREENWITTH/2-(mAKT_SCREENWITTH-(19+25+16+15));
            CGFloat deltaHeight = 65-30;
            CGFloat deltaBottom = (mAKT_SCREENHEIGHT-64-weakDrag.height-25)-(55-(55-30)/2);
            
            dynamicLayout.height.width.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(deltaHeight/deltaContainerHeight).offset(30);
            dynamicLayout.centerX.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(deltaCenterX/deltaContainerHeight).offset(mAKT_SCREENWITTH-(19+25+16+15));
            dynamicLayout.bottom.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(deltaBottom/deltaContainerHeight).offset(55-(55-30)/2);
        }];
        
        [layout addDynamicLayoutInCondition:^BOOL{
            return weakContainer.height<=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            [weakPlay setImage:mAKT_Image_Tint(@"CH_PlayLittle") forState:(UIControlStateNormal)];
            [weakPlay setImage:mAKT_Image_Tint(@"CH_PauseLittle") forState:(UIControlStateSelected)];
            
            dynamicLayout.width.equalTo(akt_value(30));
            dynamicLayout.whRatio.equalTo(akt_view(weakCover));
            dynamicLayout.centerY.equalTo(weakContainer.akt_centerY);
            dynamicLayout.right.equalTo(weakContainer.akt_right).offset(-19-25-16);
        }];
    }];
}

- (void)listLayout {
    UIImage *img = mAKT_Image_Origin(@"CH_ListLittle");
    AKTWeakView(weakContainer, self.container);
    AKTWeakView(weakCover, self.coverLittle);
    AKTWeakView(weakPlayer, self.play);
    AKTWeakView(weakDrag, self.drag);
    [self.list aktLayout:^(AKTLayoutShellAttribute *layout) {
        [layout addDynamicLayoutInCondition:^BOOL{
            return weakContainer.height>55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            CGFloat deltaRight = -30-(-19);
            CGFloat deltaContainerHeight = mAKT_SCREENHEIGHT-64-weakDrag.height-55;
            
            dynamicLayout.size.equalTo(akt_size(img.size.width, img.size.height));
            dynamicLayout.right.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(deltaRight/deltaContainerHeight).offset(mAKT_SCREENWITTH-19);
            dynamicLayout.centerY.equalTo(weakPlayer.akt_centerY);
        }];
        [layout addDynamicLayoutInCondition:^BOOL{
            return weakContainer.height<=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.width.equalTo(akt_value(img.size.width));
            dynamicLayout.whRatio.equalTo(akt_view(weakCover));
            dynamicLayout.right.equalTo(weakContainer.akt_right).offset(-19);
            dynamicLayout.centerY.equalTo(akt_view(weakContainer));
        }];
    }];
}

- (void)coverLittleLayout {
    AKTWeakView(weakContainer, self.container);
    AKTWeakView(weakMusicName, self.musicName);
    AKTWeakView(weakArtist, self.artist);
    [self.coverLittle aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.bottom.equalTo(weakContainer.akt_bottom);
        layout.width.equalTo(akt_value(55));
        [layout addDynamicLayoutInCondition:^BOOL{
            weakArtist.alpha = weakMusicName.alpha = 1.0-(weakContainer.height-55)/100.f;
            return weakContainer.height>=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.height.equalTo(akt_value(55));
            dynamicLayout.left.equalTo(weakContainer.akt_height).coefficientOffset(-55).multiple(-(55.f/150));
        }];
        [layout addDynamicLayoutInCondition:^BOOL{
            return weakContainer.height<55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.left.top.equalTo(akt_view(weakContainer));
        }];
    }];
}

- (void)nextMusicLayout {
    UIImage *img = mAKT_Image_Tint(@"CH_Next");
    [self.nextMusic setImage:img forState:(UIControlStateNormal)];
    AKTWeakView(weakPlay, self.play);
    [self.nextMusic aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.height.centerY.equalTo(akt_view(weakPlay));
        layout.whRatio.equalTo(akt_value(img.size.width/img.size.height));
        layout.left.equalTo(weakPlay.akt_right).offset(25);
    }];
}

- (void)lastMusicLayout {
    UIImage *img = mAKT_Image_Tint(@"CH_Last");
    [self.lastMusic setImage:img forState:(UIControlStateNormal)];
    AKTWeakView(weakPlay, self.play);
    [self.lastMusic aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.height.centerY.equalTo(akt_view(weakPlay));
        layout.whRatio.equalTo(akt_value(img.size.width/img.size.height));
        layout.right.equalTo(weakPlay.akt_left).offset(-25);
    }];
}

#pragma mark - click events
- (void)list:(UIButton *)btn {

}

- (void)play:(UIButton *)btn {
    if (!btn.isSelected) {// Go to play.

    }else{
    
    }
    [btn setSelected:!btn.isSelected];
}

- (void)nextMusic:(UIButton *)btn {

}

- (void)lastMusic:(UIButton *)btn {
    
}
@end
