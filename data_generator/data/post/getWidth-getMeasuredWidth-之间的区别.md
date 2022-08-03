---
title: 'getWidth(),getMeasuredWidth()之间的区别'
date: 2016-11-23 11:31:37
tags:
---

1. `getWidth()`是layout的结果，表示View所占的空间大小
2. `getMeasuredWidth()`是measured的结果，表示显示内容的View的实际大小
3. `getWidth()`大小`getMeasuredWidth()`可能不同
4. 自定义View,画图时用`getMeasuredWidth()`
5. View已经在布局后呈现出来了，想获取宽度时用`getWidth()`

http://www.cnblogs.com/summerpxy/p/4983600.html

http://www.tuicool.com/articles/RRrUny
