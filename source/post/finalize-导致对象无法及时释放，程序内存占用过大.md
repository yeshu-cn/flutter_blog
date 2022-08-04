---
title: finalize 导致对象无法及时释放，程序内存占用过大
date: 2016-09-28 17:37:45
tags:
---


感觉程序的内存占用太大了，不合理，想分析，优化一下其运行时内存的占用情况。

分析思路

1. 先用Dump Java heap查看哪个类占用的空间最大
2. 再用Allocation Tracking 分析，查看哪段代码申请的

遇到的问题

1. Allocation Tracking工具中的数据没看懂...，里面的对象总和大小和自己memory info统计出来的对不上
2. Memory monitory曲线图中的Allocated,Free两条线看不懂....


但是还是有一点成果，用Allocation Tracking中发现有个`FinalizerReference`类竟然有3656个，共占用内存116M,App运行时总共才160M, what the fuck!



## FinalizerReference 介绍

复写了`finalize()`方法的类可能会导致对象无法及时释放，程序占用过大内存，OOM。

> ava.lang.ref.FinalizerReference 是 Java/Dalvik GC 相关的一个类，所有 Override finalize() 方法的 Object，最后都会被 FinalizerReference 类的静态变量引用。所以当它们没有强引用时不会被 VM 立即回收，而是 『在GC时』会将这些 Override finalize() 方法的 Object 压入到 ReferenceQueue 中。同时会有一个守护线程『Finalize Daemon』来真正处理调用他们的 finalize() 函数，实现垃圾回收。

[Android(jave)中关于finalize必须要注意的几件事
](http://blog.csdn.net/gwgking2012/article/details/41278949)


## Java `finalize()`使用


1. `finalize()`是一个用于释放非Java资源的方法（如：文件句柄，数据库连接等）
2. 垃圾回收器回收对象时首先会调用该对象的`finalize()`方法，并且会再下一次回收时来真正的回收对象占用的内存空间
3. 复写方法时最后需要调用`super.finalize()`.

避免使用原因

1. 垃圾回收器触发回收的时机不确定
2. 需要经历两次回收才能真正的回收掉资源

[java中finalize终结方法的一些问题
](http://www.voidcn.com/blog/YJian2008/article/p-200031.html)
