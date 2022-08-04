---
title: Activity生命周期
permalink: activitysheng-ming-zhou-qi
id: 42
updated: '2015-09-13 10:38:40'
date: 2015-09-13 10:29:09
tags:
---


> 
* 显示一个非activity的Dialog,是不会调用onPause和onStop的，因为此Dialog属于activity
* 说得通俗一点就是：onPause就是你看得见，但是无法操作；onStop就是你看都看不见
* onCreate对应onDestroy 销毁跟创建， onStart对应onStop 可见与不可见都不能操作，onResum对应onPause 都可见 前者可操作后者不可操作




参考：http://www.imooc.com/qadetail/76490