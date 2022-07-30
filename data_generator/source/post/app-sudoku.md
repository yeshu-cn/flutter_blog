---
title: app_sudoku
date: 2021-12-24 12:11:14
tags:
---

# 数独

![](1.jpg)



## 使用的技术和三方库
* `intl`实现国际化
* `hive`本地存储数据
* `lottie`实现json动画播放
* `audioplayers`实现按键声音的播放
* `in_app_purchase`实现ios app内购
* `google_mobile_ads`实现奖励广告的显示
* `sudoku_solver_generator`实现数独谜题的生成
* `scoped_model`实现监听数据变化，更新相关界面的`widget`
* `sprintf`实现dart中的格式化字符串功能
* `DynamicTheme`实现主题颜色的动态设置
* 动画实现
    * 图标动画
        * 加载`json`动画实现
        * 直接使用`AnimatedIcon`
    * `SlideTransition`实现游戏填数完成时`cell`的位移动画
    * `PageTransitionSwitcher`实现草稿键盘切换显示的渐变动画
* 通过`GridView`和`cell`的`border`计算实现数独界面的表格样式
* 自定义封装`Sudoku` `widget`

## In App Purchase
### AppStore中填写好付款信息，编辑好内购的项目，内购项目分为四类

* 消耗 （服务端不保存购买状态，需要开发者自己保存）
* 非消耗（只能购买一次，重复购买会返回失败，可以通过api查询出来购买状态）
* 自动订阅
* 不自动订阅

参考：https://developer.apple.com/in-app-purchase/

### 客户端测试(有两种方法)

1. [第一种使用AppStore的沙盒账号进行测试](https://developer.apple.com/in-app-purchase/)
2. [第二种使用StoreKit进行测试](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode?preferredLanguage=occ)

注意
* StoreKit必须使用Xcode启动App，但这个必须在iOS 14后才支持。
* 沙盒账号必须在真机上测试，

## 国际化
* https://www.jianshu.com/p/dd7862e8ae66
* https://stackoverflow.com/a/68324520/1832389

## 主题
通过主题管理`Button`样式
* [MaterialButton](https://api.flutter.dev/flutter/material/MaterialButton-class.html)
* [ButtonStyle](https://api.flutter.dev/flutter/material/ButtonStyle-class.html)

**总结**
* `MaterialButton` 弃用了。
* 使用`TextButton`,`ElevatedButton`,`OutlinedButton`替换原来的`FlatButton`,`RaisedButton`,`OutlineButton`。
* 使用`ButtonStyle`来定义按键的样式，可以通过`TextButton.styleFrom（）`来创建`ButtonStyle`。

**定义单个按钮的样式**
```dart
TextButton(
  style: TextButton.styleFrom(primary: Colors.green),
)
```
**通过主题定义按钮样式**
```dart
MaterialApp(
  theme: ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.green),
    ),
  ),
  home: MyAppHome(),
)
```

## 动画框架

动画设计：Material motion system
* Container transform
* Shared axis
* Fade through
* Fade

对应实现：Flutter animation package
* Container transform
* Shared axis transition
* Fade through transition
* Fade transition

## 知识点
* Containers with no children try to be as big as possible
* GridView高度不能wrap_content,GridView在Column中高度会莫名其妙的多处一点，只有把它放在ListView中就好了。
* ListView默认会多出一个间隔[Unexpected top padding in ListView put inside scaffold with no appBar](https://github.com/flutter/flutter/issues/14842)

```dart
return MediaQuery.removePadding(
    context: context,
    removeTop: true,
    child: ListView.builder(
     .......
    )
```

