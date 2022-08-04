---
title: onSaveInstanceState()何时调用
permalink: onsaveinstancestatehe-shi-diao-yong
id: 43
updated: '2015-09-13 14:37:40'
date: 2015-09-13 14:32:04
tags:
---

当Activity可能被销毁时，就会被调用

* 按下home键时
* 长按home键
* 横竖屏切换
* 屏幕关闭时
* 从Activty A中启动一个新的Activity

默认的onSaveInstanceSate()函数会保存当前Activity中控件的一些属性，例如EditText输入的数据等。但是必须给这个控件指定一个id