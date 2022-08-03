---
title: Fragment 使用注意事项
permalink: fragment-shi-yong-zhu-yi-shi-xiang
id: 72
updated: '2016-04-19 03:55:37'
date: 2016-04-19 03:50:01
tags:
---

1. 使用`newInstance()`方法来获取实例，使用`setArguments`来传递参数，避免在横竖屏切换的时候`Fragment`自动调用自己的无参构造函数，导致数据丢失。

2. `commitAllowingStateLoss()`状态丢失问题

状态丢失是指`onSaveInstance()`的时候没有把`fragment`的状态保存进去，所以必须在调用`onSaveInstance()`之间加载`fragment`。实在没办法就使用`commitAllowingStateLoss()`。

具体参考:<http://blog.jobbole.com/66117/>


