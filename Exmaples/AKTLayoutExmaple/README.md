[ ![AKTKit.AKTLayout](https://raw.githubusercontent.com/AkteamYang/AKTKit.AKTLayout/master/Imgs/AKTLayout.jpg) ](https://github.com/AkteamYang/AKTKit.AKTLayout)
#[AKTLayout](https://github.com/AkteamYang/AKTKit.AKTLayout)
https://github.com/AkteamYang/AKTKit.AKTLayout

AKTLayout是一个服务于IOS平台的高性能自动布局框架。

![AKTKit.AKTLayout](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/Demo/Demo1.gif?raw=true)
> 动态特性

####参照类型 

| vertical  | horizontal  |
| :------------: | :------------: |
| top  | left  |
| bottom  | right  |
| height  |  width |
| centerY  | centerX  |

参照分为垂直和水平方向，在不设置长宽比例的情况下，每个方向只要有两个参照就足够足够确定view的大小和位置。size、whRatio和edge较为特殊，直接参照size、宽高比和edge，过多的参照将会被舍弃，不同的参照关系最终将转化到坐标关系，下面我将详细描述参照。

![AKTKit.AKTLayout](https://github.com/AkteamYang/AKTKit.AKTLayout/blob/master/Imgs/Demo/reference.png?raw=true)
> 参照最终体现到坐标值，除了的`size`和`edge`之外，其余的参照都可以参考固定值和视图，为了提高运算效率参照的写法做了特殊规定，只能通过框架提供的固定方法获取：`aktValue()`、`aktView()`、`aktSize()`、`view.akt_top、view.akt_width......`

####静态布局
- 静态布局的基本结构：
```objective-c
        [sub aktLayout:^(AKTLayoutShellAttribute *layout) {
            layout.centerXY.equalTo(akt_view(v));
            layout.size.equalTo(akt_view(v)).multiple(.33);
        }];
```

- 基础用法

`layout.top.left.equalTo(akt_value(0));` 视图的顶部和左边缘坐标值等于0

`layout.width.equalTo(_tableView.akt_width);` 视图的宽度等于`tableView`的宽度

`layout.whRatio.equalTo(aktView(_tableView));` 视图的宽高比等于视图`tableView`的宽高比

`layout.whRatio.equalTo(aktValue(1.0f));` 视图的宽高比等于1.0f

`layout.size.equalTo(aktView(_tableView));` 视图的宽高等于`_tableView`的宽高

`layout.edge.equalTo(aktView(_tableView));` 视图的边缘位置等于`_tableView`的边缘位置，即重合

- 进阶用法

`layout.top.left.equalTo(akt_value(10)).multiple(1.5);` 视图的顶部和左边缘坐标值等于10*1.5,即15

`layout.top.left.equalTo(akt_value(10)).multiple(1.5).offset(2);` 视图的顶部和左边缘坐标值等于10*1.5+2,即17

`layout.top.left.equalTo(akt_value(10)).coefficientOffset(5).multiple(1).offset(2);` 视图的顶部和左边缘坐标值等于(10+5)*1+2,即17

####动态布局
- 动态布局的基本结构：

```objective-c
        AKTWeakView(__self, self);
        AKTWeakView(__Img, self.img);
        [_title aktLayout:^(AKTLayoutShellAttribute *layout) {
        	// 动态布局部分
            [layout addDynamicLayoutInCondition:^BOOL{
                return mAKT_Portrait;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.top.centerY.equalTo(akt_view(__self));
                dynamicLayout.left.equalTo(__self.img.akt_right).offset(20);
            }];
            [layout addDynamicLayoutInCondition:^BOOL{
                return !mAKT_Portrait;
            } andAttribute:^(AKTLayoutShellAttribute *dynamicLayout) {
                dynamicLayout.top.equalTo(akt_view(__Img)).offset(10);
                dynamicLayout.left.equalTo(__Img.akt_right).offset(20);
            }];
        }];
``` 
- 基本用法

动态布局用法和静态一样，只不过调用主体变成`dynamicLayout` ,使用的时候需要把`condition`和`attribute`block用到的视图参照声明为弱引用。

`dynamicLayout.top.left.equalTo(akt_value(0));` 视图的顶部和左边缘坐标值等于0

`dynamicLayout.width.equalTo(_tableView.akt_width);` 视图的宽度等于`tableView`的宽度

`dynamicLayout.whRatio.equalTo(aktView(_tableView));` 视图的宽高比等于视图`tableView`的宽高比

`dynamicLayout.whRatio.equalTo(aktValue(1.0f));` 视图的宽高比等于1.0f

`dynamicLayout.size.equalTo(aktView(_tableView));` 视图的宽高等于`_tableView`的宽高

`dynamicLayout.edge.equalTo(aktView(_tableView));` 视图的边缘位置等于`_tableView`的边缘位置，即重合


`dynamicLayout.top.left.equalTo(akt_value(10)).multiple(1.5);` 视图的顶部和左边缘坐标值等于10*1.5,即15

`dynamicLayout.top.left.equalTo(akt_value(10)).multiple(1.5).offset(2);` 视图的顶部和左边缘坐标值等于10*1.5+2,即17

`dynamicLayout.top.left.equalTo(akt_value(10)).coefficientOffset(5).multiple(1).offset(2);` 视图的顶部和左边缘坐标值等于(10+5)*1+2,即17

- 关于`condition`和`attribute`

当`condition`返回为`YES`的时候布局将会使用对应的动态布局部分，`condition`block会被频繁调用不应该放置和条件判断无关的操作，`attribute`block只有需要更新动态布局时才会被调用，如果`condition`条件成立，但是上次和本次布局相同，`attribute`也不会被调用。由于二者会被长期持有，我们在`condition`和`attribute`中使用变量时尤其是参考的的视图需要声明为弱引用，其他对象的使用可以按照需要决定。

####其他
- 混合布局

AKTLayout很灵活,在应对复杂布局的时候，支持使用一些`frame`计算,具体的做法是我们给视图添加部分AKTLayout布局，然后在必要的时候我们可以设置`frame`并调用`setNeedAKTLayout`方法来刷新`AKTLayout`的布局，最终得到的将是二者叠加的效果。
- AKTLayout事件

AKTLayout提供了布局完成事件接口`- (void)aktDidLayoutTarget:(id)target forSelector:(SEL)selector;`和`- (void)aktDidLayoutWithComplete:(void(^)(UIView *view))complete;`，您可以自己选择方法，`block`会被长期持有，注意循环引用的问题。


###FAQ&Contact

------------
目前已在9.0系统完成测试，低版本系统后续完成测试。

如果您在运行中发现了问题、对有些特性存在疑惑或者有pull request，你可以在[issue](https://github.com/AkteamYang/AKTKit.AKTLayout/issues "issue")创建一个问题。您也可以在我的[简书](http://www.jianshu.com/p/901cde2d4044)中进行评论，或者给我发送邮件battle0001@sina.com。
