![AKTKit.AKTLayout](https://raw.githubusercontent.com/AkteamYang/AKTKit.AKTLayout/master/Imgs/AKTLayout.jpg)
#AKTLayout
AKTLayout是一个服务于IOS平台的自动布局框架，由于系统的自动布局在复杂的界面呈现中，无法展现较高的性能（Masonry、PrueLayout、FLKAutoLayout...都是基于NSLayoutConstraint的自动布局书写框架）。AKTLayout最初的目的仅仅是为了简化手动布局时的代码编写，后来加入了内建的自动布局引擎，这才有了令人惊喜的特性。

这是AKTLayout的初级版本，某些特性让我很惊喜，我们将不断完善功能和细节表现。
###New beginning

------------

![orientation](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/AutoLayout.gif?raw=true)
> 通过**AKTLayout**实现的自动布局
以图片为中心，四周的矩形各有一个顶点和图片顶点相连，色块内部的白色矩形为子视图，参考了父视图的中心点和两个边缘。

###Setup

------------
- **从GitHub手动获取**
1. 从[AKTKit.AKTLayout](https://github.com/AkteamYang/AKTKit.AKTLayout/releases "AKTKit.AKTLayout")中下载资源文件
2. 添加资源文件到你的Xcode工程中
3. 导入头文件`#import "AKTKit.h"`
- ** 使用CocoaPods**
等待后续更新...


###Usage

------------


- **Add layout**
采用了类似于Masonry的语法，快速地书写布局代码，拥有较为丰富和易于使用的API。

	![Demo1](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/orientation.gif?raw=true "Demo1")

	```objective-c
	// 蓝色矩形布局
    [v1 aktLayout:^(AKTLayoutShellAttribute *layout) {
			// 中心点Y坐标与self.view中心点Y对齐
			layout.centerY.equalTo(akt_view(self.view));
			// 高度是self.view的高度的0.33倍
			layout.height.equalTo(akt_view(self.view)).multiple(.33);
			// 左边缘与self.view左边缘对齐
			layout.left.equalTo(self.view.akt_left).offset(space);
			// 右边缘与self.view的中心点X坐标对齐并左偏移space／2
			layout.right.equalTo(self.view.akt_centerX).offset(-space/2);
    }];
```
- **Animation**
AKTLayout动画的添加和普通的动画添加没有区别

	![animation](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/animation.gif?raw=true "animation")
	1. **如果您仅仅需要暂时添加动画**
	```objective-c
[UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.2 options:0 animations:^{
            tap.view.frame = CGRectMake((self.view.width-150)/2, (self.view.height-150)/2, 150, 150);
        } completion:^(BOOL finished) {
			nil;
}];
```
> 在动画代码块中修改frame，如果发生布局更新，界面将恢复到动画前的状态

	2. 非暂时修改
	```objective-c
[UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:1.f initialSpringVelocity:.2 options:0 animations:^{
			[view aktLayout:^(AKTLayoutShellAttribute *layout) {
				layout.centerXY.equalTo(akt_view(self.view));
				layout.height.width.equalTo(self.view.akt_width).multiple(.6);
			}];
} completion:^(BOOL finished) {
			nil;
}];
```
> 在动画代码块中重新添加AKTLayout，如果发生布局更新，界面将保持动画后的状态，新的AKTLayout布局将会替换旧的。

###Implementation architecture

------------

- **Architecture **
![实现架构](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/architecture.png?raw=true "实现架构")
> 实现架构

	AKTLayou顶层采用了基于Objective-C语法的shell，通过shell我们可以快速地书写布局代码，底层采用了基于纯C的参考解析和运算系统。

- **Reference Type Supported**

| vertical  | horizontal  | other  |
| :------------: | :------------: |  :------------: |
| top  | left  | size |
| bottom  | right  | edgeInset |
| height  |  width | offset |
| centerY  | centerX  | multiple |
| whRation  | whRation  | * |
支持添加同级别跨级别视图之间的相对参照，不支持自身布局属性之间的参照。

- **Performance Analysis**

### FAQ&Contact

------------
如果您在运行中发现了问题、对有些特性存在疑惑或者有pull request，你可以在[issue](https://github.com/AkteamYang/AKTKit.AKTLayout/issues "issue")创建一个问题。您也可以在我的简书中进行评论，或者给我发送邮件battle0001@sina.com。


