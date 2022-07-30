---
title: focusableInTouchMode属性导致第一次点击事件失效
date: 2016-10-10 18:14:26
tags:
---

> 大多数控件都可以获得焦点，也就是处在选中状态，如果android:focusable属性值为true，表示可以通过键盘（虚拟键盘或者物理键盘）或者轨迹球将焦点移动到当前控件上，如果该属性值为false，则无法将焦点移动到当前控件。  
> 
在默认情况下，触摸一个按钮虽然可以触发该控件的单机事件，但无法使控件处在焦点状态。而将andorid:focusableInTouchMode属性值设为true，当触摸某个控件时，会先将焦点移动到被触摸的控件上，然后需要在触摸该控件才会响应单击事件。但是要注意的是们需要将android:focusable属性值设为true，当前控件才可能获得焦点，否则当前控件无论使用何种方式都无法获得焦点。

from:http://blog.csdn.net/lintcgirl/article/details/48059431
