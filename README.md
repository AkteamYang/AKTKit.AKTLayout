[ ![AKTKit.AKTLayout](https://raw.githubusercontent.com/AkteamYang/AKTKit.AKTLayout/master/Imgs/AKTLayout.jpg) ](https://github.com/AkteamYang/AKTKit.AKTLayout)
#[AKTLayout](https://github.com/AkteamYang/AKTKit.AKTLayout)
https://github.com/AkteamYang/AKTKit.AKTLayout

AKTLayout是一个服务于IOS平台的高性能自动布局框架，由于系统的自动布局在复杂的界面呈现中，性能衰减十分严重（Masonry、PureLayout、FLKAutoLayout...都是基于`NSLayoutConstraint`的自动布局书写框架）。AKTLayout最初的目的仅仅是为了简化手动布局时的代码编写，后来引入了高性能的内建自动布局引擎，展现出令人惊喜的特性。

###New update
-----------------
####V 1.2.0  
更新日期2016.5.21
- 布局更新性能相比1.0.0提升约300%！
- 移除对于UIView生命周期的介入性操作，不再需要手动控制UIView的生命周期，降低使用成本
- 更新动画接口
![compare with v1.0.0](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/compare.jpg?raw=true)
>1.2.0版本布局更新性能的提升还是非常明显的，主要更新了布局刷新的函数调用方式以及view的布局更新逻辑。由于view是相互参照的，某个view的变化会带动相关联的view的变化，在复杂布局中，这些关联关系常常是有重叠的，这样也就导致，同一个view可能被多次计算，理论上来讲只有最后一次计算才是有效的。目前AKTLayout 1.2.0采用最为高效的工作方式自动忽略无效的计算。


###New beginning
---------------
![orientation](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/AutoLayout.gif?raw=true)
> 通过**AKTLayout**实现的自动布局
以图片为中心，四周的矩形各有一个顶点和图片顶点相连，色块内部的白色矩形为子视图，参考了父视图的中心点和两个边缘。

###Setup

------------
- **从GitHub手动获取**
	
	1.从[AKTKit.AKTLayout](https://github.com/AkteamYang/AKTKit.AKTLayout/releases "AKTKit.AKTLayout")中下载资源文件

	2.添加资源文件到你的Xcode工程中
	
	3.导入头文件`#import "AKTKit.h"`， `"UIView+ViewAttribute.m"`需要加入MRC编译选项`-fno-objc-arc`
- **使用CocoaPods**
	
	等待后续更新...


###Usage

------------


- **Add layout**

快速地书写布局代码，拥有较为丰富和易于使用的API。
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
			// 添加参考 enqualTo("AKTReference")
			// 参考类型的创建(AKTReference)：视图、值、size、视图的布局属性
			// 视图: akt_value(VALUE)
			// 值: akt_view(VIEW)
			// size: akt_size(WIDTH, HEIGHT)
			// 布局属性： self.view.akt_left
    }];
```
- **Animation**

	AKTLayout动画的添加和普通的动画添加没有区别，仅仅需要在AKTLayout动画环境代码块中提交您的动画代码

	![animation](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/animation.gif?raw=true "animation")
	
	
 1. **如果您仅仅需要暂时添加动画**
	```objective-c
[UIView aktAnimation:^{
        [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.2 options:0 animations:^{
            tap.enabled = NO;
            tap.view.frame = CGRectMake((self.view.width-150)/2, (self.view.height-150)/2, 150, 150);
        } completion:^(BOOL finished) {
            tap.enabled = YES;
        }];
	}];
```
	> 在动画代码块中修改frame，如果发生布局更新，界面将恢复到动画前的状态

 2. **非暂时修改**
	```objective-c
[UIView aktAnimation:^{
	    [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.2 options:0 animations:^{
	        tap.enabled = NO;
	        [tap.view aktLayout:^(AKTLayoutShellAttribute *layout) {
	            layout.centerXY.equalTo(akt_view(self.view));
	            layout.height.width.equalTo(akt_value(200));
	        }];
	    } completion:^(BOOL finished) {
	        tap.enabled = YES;
	    }];
}];
```
	> 在动画代码块中重新添加AKTLayout，如果发生布局更新，界面将保持动画后的状态，新的AKTLayout布局将会替换旧的。

###Implementation architecture

------------

- **Architecture**

![AKTLayout架构](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/architecture.jpg?raw=true "实现架构")
> AKTLayout架构
AKTLayou顶层采用了基于Objective-C语法的shell，通过shell我们可以快速地书写布局代码，底层采用了基于纯C的参考解析、参考运算系统和布局更新系统。

- **Reference Type Supported**

| vertical  | horizontal  | other  |
| :------------: | :------------: |  :------------: |
| top  | left  | size |
| bottom  | right  | edgeInset |
| height  |  width | offset |
| centerY  | centerX  | multiple |
| whRation  | whRation  | * |

支持添加同级别跨级别视图之间的相对参照，不支持自身布局属性之间的参照和循环参照。

- **Performance Analysis**

	在复杂布局中应用`NSLayoutConstraint`来进行自动布局，性能往往不令人满意。通常的做法是通过手写`frame`布局来提升性能。AKTLayout采用高性能的布局添加和运算架构，响应式布局更新算法，高效地实现自动布局。以下我们对frame、AKTLayout 和Masonry进行了性能比较（Platform：iPhone 6 SystemVersion：9.3.1）。

	![iOS](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/screenShot.jpg?raw=true)
- 关于参考复杂度
	![Reference](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/reference.jpg?raw=true)
> 图片展示了下文所测试的四种等级的视图参考，简单来讲越复杂的参考view间的关系越复杂，某个view的变化将影响相关的view进行布局刷新。

这里我还需要解释一下，为什么测试中要用这么多数量的View，有人说平时不可能遇到这么多view的情况。首先第一，数量多是为了便于观察性能的消耗情况，第二我们关注的重点是不同布局方式的运行效率，有兴趣的话可以自己将总时间换算成不同复杂度下的单个view布局的耗时。

  1. **布局的添加**
	
  ![AddLayout](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/addLayout.jpg?raw=true "addLayout")
	
  > view的数量线性增长，同时view的参考复杂度逐级提高（I～IIII）IIII级是接近日常使用中的参考复杂度的，Masonry添加布局效率衰减十分严重，在快速响应的UITableView上使用Masonry是必卡无疑的。

  2. **布局更新**
  ![更新布局](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/updateLayout.jpg?raw=true "更新布局")
	
  > 随着布局复杂度的增长，`NSLayoutConstraint`布局更新效率下降严重，AKTLayout布局更新效率稳定，由于手动布局无法自动更新所以在这里不参与比较。
  > 运算量比值`NSLayoutConstraint` : `AKTLayout` 3:1、13.4:1 、22.8:1
	
AKTLyout采用优化的响应式布局更新系统，自动忽略无效的计算。当某个视图布局发生变化时，自动重计算参照此视图的视图布局，在复杂的参照布局中依然保持高性能。

###FAQ&Contact

------------
目前已在9.0系统完成测试，低版本系统后续完成测试。

如果您在运行中发现了问题、对有些特性存在疑惑或者有pull request，你可以在[issue](https://github.com/AkteamYang/AKTKit.AKTLayout/issues "issue")创建一个问题。您也可以在我的[简书](http://www.jianshu.com/p/901cde2d4044)中进行评论，或者给我发送邮件battle0001@sina.com。
