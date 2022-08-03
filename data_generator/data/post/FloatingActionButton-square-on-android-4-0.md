---
title: FloatingActionButton square on android 4.0
permalink: floatingactionbutton-square-on-android-4-0
id: 25
updated: '2015-07-28 08:55:05'
date: 2015-07-28 08:47:05
tags:
---

`com.android.support:design:22.2.0`的一个Bug:
FloatingActionButton 在android 4.0上显示正方形

解决方法
1. 添加属性`app:borderWidth="0dp"`
2. 使用`com.android.support:design:22.2.1`

资料：https://code.google.com/p/android/issues/detail?id=175067