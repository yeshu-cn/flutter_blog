---
title: java final 作用
date: 2016-09-12 19:49:10
tags:
---

##### final 作用
* final修饰基本类型，基本类型的值不能变
* final修饰引用类型，引用指向的内存地址不能变，但是内存地址的值是可以变化的

##### 内部类使用外部变量必需是final的
内部类会拷贝外部变量的引用，为防止拷贝的数据和外部变量不一致，才使用final修饰。

##### 资料  
[java提高篇(十)-----详解匿名内部类](http://www.cnblogs.com/chenssy/p/3390871.html)  
[java为什么匿名内部类的参数引用时final?](https://www.zhihu.com/question/21395848)
