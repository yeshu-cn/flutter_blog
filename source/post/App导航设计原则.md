---
title: App导航设计原则
date: 2018-07-25 16:02:18
tags:
---

# 导航的设计原则

遵循导航的设计原则是为了给用户提供一个统一的，可预期的用户体验

## App只有一个固定的主页面

*  用户启动程序后看到的页面
*  用户退出时看到的页面

初始化页面，登录页面不算

## stack表示app的导航状态

`naviagtion stack`最底层的应该是`start desination`,最顶层是`current destination`


## Up按钮

* at the start destination, the Up button should not be shown
* 当通过第三方启动app时，up按钮应该执行自己app的退出逻辑，不需要返回第三方app

## Up按键和Back按键效果一样

## 通过Deep linking跳转进入到目的页面时，导航也应该遵循正常的返回逻辑


from:https://developer.android.com/topic/libraries/architecture/navigation/navigation-principles
