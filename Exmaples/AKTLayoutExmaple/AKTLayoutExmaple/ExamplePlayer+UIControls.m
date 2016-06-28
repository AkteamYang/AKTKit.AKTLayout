//
//  ExamplePlayer+UIControls.m
//  AKTLayoutExmaple
//
//  Created by YaHaoo on 16/6/21.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "ExamplePlayer+UIControls.h"
#import "AKTKit.h"
#import <AVFoundation/AVFoundation.h>

//--------------# Macro & Const #--------------
#define kExampleTint mAKT_Color_Color(80, 128, 215, 1)
//--------------# E.n.d #--------------#>Macro
@interface ExamplePlayer()
@property (assign, nonatomic) BOOL coverHeight;
@end

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
    [self modeMake];
    [self sliderMake];
    [self currentTimeMake];
    [self durationMake];
    [self topMusicNameMake];
    [self topArtistMake];
    [self coverMake];
    // 为container添加布局结束事件
    [self.container aktDidLayoutTarget:self forSelector:@selector(containerDidLayout:)];
    
    // Add layout.
    [self coverLittleLayout];
    [self playLayout];
    [self listLayout];
    [self nextMusicLayout];
    [self lastMusicLayout];
    [self modeLayout];
    [self sliderLayout];
    [self currentTimeLayout];
    [self durationLayout];
    [self topMusicNameLayout];
    [self topArtistLayout];
    [self coverLayout];
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
        UIImage *img = mAKT_Image(@"CH_ListBig");
        [self.list setImage:img forState:(UIControlStateNormal)];
        self.list.aktName = @"listButton";
        [self.list setTintColor:kExampleTint];
        self.list.frame = CGRectMake(0, 0, img.size.width, img.size.height);
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
        self.nextMusic.alpha = 0;
    }
}

- (void)lastMusicMake {
    if (!self.lastMusic) {
        self.lastMusic = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.container addSubview:self.lastMusic];
        self.lastMusic.aktName = @"lastMusicButton";
        [self.lastMusic setTintColor:kExampleTint];
        [self.lastMusic addTarget:self action:@selector(lastMusic:) forControlEvents:(UIControlEventTouchUpInside)];
        self.lastMusic.alpha = 0;
    }
}

- (void)modeMake {
    if (!self.mode) {
        self.mode = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.container addSubview:self.mode];
        [self.mode setImage:mAKT_Image_Tint(@"CH_Mode0") forState:(UIControlStateNormal)];
        [self.mode setImage:mAKT_Image_Tint(@"CH_Mode1") forState:(UIControlStateSelected)];
        self.mode.aktName = @"modeButton";
        [self.mode setTintColor:kExampleTint];
        [self.mode addTarget:self action:@selector(mode:) forControlEvents:(UIControlEventTouchUpInside)];
        self.mode.alpha = 0;
    }
}

- (void)sliderMake {
    if (!self.slider) {
        self.slider = [[UISlider alloc]init];
        [self.container addSubview:self.slider];
        self.slider.aktName = @"slider";
        [self.slider setTintColor:kExampleTint];
        self.slider.continuous = NO;
        [self.slider setThumbImage:mAKT_Image_Tint(@"slider") forState:(UIControlStateNormal)];
        self.slider.value = 0.0;
        [self.slider addTarget:self action:@selector(slider:) forControlEvents:(UIControlEventValueChanged)];
        self.slider.alpha = 0;
    }
}

- (void)currentTimeMake {
    if (!self.currentTime) {
        self.currentTime = [UILabel new];
        [self.container addSubview:self.currentTime];
        self.currentTime.aktName = @"currentTime";
        self.currentTime.text = @"00:00";
        self.currentTime.textColor = mAKT_Color_Text_52;
        self.currentTime.font = mAKT_Font_12;
        self.currentTime.numberOfLines = 1;
        self.currentTime.alpha = 0;
    }
}

- (void)durationMake {
    if (!self.duration) {
        self.duration = [UILabel new];
        [self.container addSubview:self.duration];
        self.duration.aktName = @"duration";
        self.duration.text = @"00:00";
        self.duration.textColor = mAKT_Color_Text_52;
        self.duration.font = mAKT_Font_12;
        self.duration.numberOfLines = 1;
        self.duration.alpha = 0;
    }
}

- (void)topMusicNameMake {
    if (!self.topMusicName) {
        self.topMusicName = [UILabel new];
        [self.container addSubview:self.topMusicName];
        self.topMusicName.aktName = @"topMusicName";
        self.topMusicName.text = self.musicName.text;
        self.topMusicName.textColor = kExampleTint;
        self.topMusicName.font = mAKT_Font_18;
        self.topMusicName.numberOfLines = 1;
        self.topMusicName.alpha = 0;
    }
}

- (void)topArtistMake {
    if (!self.topArtist) {
        self.topArtist = [UILabel new];
        [self.container addSubview:self.topArtist];
        self.topArtist.aktName = @"topArtist";
        self.topArtist.text = self.artist.text;
        self.topArtist.textColor = self.artist.textColor;
        self.topArtist.font = mAKT_Font_14;
        self.topArtist.numberOfLines = 1;
        self.topArtist.alpha = 0;
    }
}

- (void)coverMake {
    if (!self.cover) {
        self.cover = [ExampleCoverView new];
        [self.container addSubview:self.cover];
        self.cover.alpha = 0;
    }
}

#pragma mark - view settings
- (void)playLayout {
    // The view you'll reference to will be declared as weak reference.
    AKTWeakView(__container, self.container);
    AKTWeakView(__play, self.play);
    AKTWeakView(__coverLittle, self.coverLittle);
    [self.play aktLayout:^(AKTLayoutShellAttribute *layout) {
        // Add dynamic layout for different conditions.
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height>55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            [__play setImage:mAKT_Image_Tint(@"CH_PlayBig") forState:(UIControlStateNormal)];
            [__play setImage:mAKT_Image_Tint(@"CH_PauseBig") forState:(UIControlStateSelected)];
        }];
        
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height<=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            [__play setImage:mAKT_Image_Tint(@"CH_PlayLittle") forState:(UIControlStateNormal)];
            [__play setImage:mAKT_Image_Tint(@"CH_PauseLittle") forState:(UIControlStateSelected)];
            
            dynamicLayout.width.equalTo(akt_value(30));
            dynamicLayout.whRatio.equalTo(akt_view(__coverLittle));
            dynamicLayout.centerY.equalTo(__container.akt_centerY);
            dynamicLayout.right.equalTo(__container.akt_right).offset(-19-25-16);
        }];
    }];
}

- (void)listLayout {
    AKTWeakView(__container, self.container);
    AKTWeakView(__coverLittle, self.coverLittle);
    AKTWeakView(__player, self.play);
    [self.list aktLayout:^(AKTLayoutShellAttribute *layout) {
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height>55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.centerY.equalTo(__player.akt_centerY);
        }];
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height<=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.whRatio.equalTo(akt_view(__coverLittle));
            dynamicLayout.right.equalTo(__container.akt_right).offset(-12);
            dynamicLayout.centerY.equalTo(akt_view(__container));
        }];
    }];
}

- (void)coverLittleLayout {
    AKTWeakView(__container, self.container);
    [self.coverLittle aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.bottom.equalTo(self.container.akt_bottom);
        layout.width.equalTo(akt_value(55));
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height>55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.height.equalTo(akt_value(55));
        }];
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height<=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.left.top.equalTo(akt_view(__container));
        }];
    }];
}

- (void)nextMusicLayout {
    UIImage *img = mAKT_Image_Tint(@"CH_Next");
    [self.nextMusic setImage:img forState:(UIControlStateNormal)];
    [self.nextMusic aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.height.centerY.equalTo(akt_view(self.play));
        layout.whRatio.equalTo(akt_value(img.size.width/img.size.height));
        layout.left.equalTo(self.play.akt_right).offset(25);
    }];
}

- (void)lastMusicLayout {
    UIImage *img = mAKT_Image_Tint(@"CH_Last");
    [self.lastMusic setImage:img forState:(UIControlStateNormal)];
    [self.lastMusic aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.height.centerY.equalTo(akt_view(self.play));
        layout.whRatio.equalTo(akt_value(img.size.width/img.size.height));
        layout.right.equalTo(self.play.akt_left).offset(-25);
    }];
}

- (void)modeLayout {
    UIImage *img = mAKT_Image_Tint(@"CH_Mode0");
    AKTWeakView(__container, self.container);
    [self.mode aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerY.equalTo(self.play.akt_centerY);
        layout.size.equalTo(akt_size(img.size.width, img.size.height));
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height<=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.left.equalTo(__container.akt_left).offset(12);
        }];
    }];
}

- (void)sliderLayout {
    [self.slider aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerX.equalTo(akt_view(self.container));
        layout.height.equalTo(akt_value(40));
        layout.left.equalTo(akt_value(50));
        layout.bottom.equalTo(self.play.akt_top).offset(-25);
    }];
}

- (void)currentTimeLayout {
    AKTWeakView(__slider, self.slider);
    AKTWeakView(__container, self.container);
    [self.currentTime aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerY.equalTo(akt_view(self.slider));
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height<=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.right.equalTo(__slider.akt_left).offset(-50);
        }];
    }];
    self.currentTime.text = self.currentTime.text;
}

- (void)durationLayout {
    AKTWeakView(__slider, self.slider);
    AKTWeakView(__container, self.container);
    [self.duration aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerY.equalTo(akt_view(self.slider));
        [layout addDynamicLayoutInCondition:^BOOL{
            return __container.height<=55;
        } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
            dynamicLayout.left.equalTo(__slider.akt_right).offset(50);
        }];
    }];
    self.duration.text = self.duration.text;
}

- (void)topMusicNameLayout {
    [self.topMusicName aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerX.equalTo(akt_view(self.container));
        layout.top.equalTo(self.container.akt_top).offset(10);
    }];
    self.topMusicName.text = self.topMusicName.text;
}

- (void)topArtistLayout {
    [self.topArtist aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.centerX.equalTo(akt_view(self.topMusicName));
        layout.top.equalTo(self.topMusicName.akt_bottom).offset(5);
    }];
    self.topArtist.text = self.artist.text;
}

- (void)coverLayout {
    // 这里仅仅添加了垂直方向居中和宽高比，宽度和垂直方向的位置在container布局完成后直接设置frame
    [self.cover aktLayout:^(AKTLayoutShellAttribute *layout) {
        layout.whRatio.equalTo(akt_value(1));
        layout.centerX.equalTo(akt_view(self.container));
    }];
}

#pragma mark - click events
/**
 *  Container 布局完成，在这里根据container的高度来动态地改变自视图的状态和位置, 在复杂布局中为了获得更大的灵活性， AKTLayout支持与frame混合布局
 *  我们可以设置一部分AKTLayout约束，然后在设置完frame之后调用“setNeedAKTLayout”来更新到最新布局结果。
 *
 *  @param view
 */
- (void)containerDidLayout:(UIView *)view {
    CGFloat percent = (view.height -55)/(mAKT_SCREENHEIGHT-64-self.drag.height-55);
    self.topMusicName.alpha
    = self.topArtist.alpha
    = self.cover.alpha
    = self.duration.alpha
    = self.currentTime.alpha
    = self.slider.alpha
    = self.mode.alpha
    = self.nextMusic.alpha
    = self.lastMusic.alpha
    = percent*2-1;
    
    self.artist.alpha = self.musicName.alpha = 1.0-(view.height-55)/100.f;
    if (view.height>55) {
        // Play button layout.
        CGFloat deltaCenterX = mAKT_SCREENWITTH/2-(mAKT_SCREENWITTH-(19+25+16+15));
        CGFloat deltaHeight = 65-30;
        CGFloat deltaTop = (mAKT_SCREENHEIGHT-64-self.drag.height-35-65)-(55-30)/2.0f;
        
        CGFloat centerX = percent*deltaCenterX+mAKT_SCREENWITTH-(19+25+16+15);
        CGFloat height = percent*deltaHeight+30;
        CGFloat top = percent*deltaTop+(55-30)/2.0f;
        self.play.frame = CGRectMake(centerX-height/2.0f, top, height, height);

        // 由于以下frame设置并未影响他们AKTLayout布局的效果，所以不必再调用“setNeedAKTLayout”，例如：您通过AKTLayout设置了A的Size，然后通过frame改变A的(x，y), 在这时候AKTLayout所约束的size其实时没有变化的，所以不必调用"setNeedAKTLayout"来刷新结果，如果您不确定影响，最好调用以下这个方法。
        // CoverSmall
        self.coverLittle.x = percent*-55;
        // ListButton
        CGFloat deltaLeft = -15-(-12);
        self.list.frame = CGRectMake(percent*deltaLeft+mAKT_SCREENWITTH-12-self.list.width, self.list.y, self.list.width, self.list.height);
        // ModeButton
        self.mode.x = percent*15;
        // CurrentTime
        self.currentTime.x = (50-6)*percent+(-self.currentTime.width);
        // Duration
        self.duration.x = -(50-6)*percent+mAKT_SCREENWITTH;
    }
    
    // Cover layout
    CGFloat coverMaxHeight = self.slider.y-self.topArtist.y-self.topArtist.height;
    if (ABS(coverMaxHeight)>mAKT_SCREENWITTH) {
        self.cover.width = mAKT_SCREENWITTH*.9;
    }else{
        self.cover.width = coverMaxHeight*.9;
    }
    self.cover.y = (self.slider.y+self.topArtist.y+self.topArtist.height)/2-(self.cover.width)/2;
    [self.cover setNeedAKTLayout];
}

- (void)list:(UIButton *)btn {
    
}

- (void)play:(UIButton *)btn {
    if (!btn.isSelected) {// Go to play.
        
    }else{
        
    }
    [btn setSelected:!btn.isSelected];
}

- (void)mode:(UIButton *)btn {
    if (!btn.isSelected) {// Go to play.

    }else{

    }
    [btn setSelected:!btn.isSelected];
}

- (void)nextMusic:(UIButton *)btn {
    
}

- (void)lastMusic:(UIButton *)btn {
    
}

- (void)slider:(UISlider *)slider {
    
}

@end
