---
title: Android性能优化笔记
date: 2016-09-29 17:41:47
tags:
---


## Work flow

1. 分析App内存使用，解决内存泄漏
2. 分析App哪些地方导致使用了大量内存
3. 使用Lints等代码审核工具完善代码


## 常见优化目标 

* 过度绘制
* 内存抖动
* 使用SparseArray
> 利用Android Framework里面优化过的容器类，例如SparseArray, SparseBooleanArray, 与 LongSparseArray。 通常的HashMap的实现方式更加消耗内存，因为它需要一个额外的实例对象来记录Mapping操作。另外，SparseArray更加高效在于他们避免了对key与value的autobox自动装箱，并且避免了装箱后的解箱。

* 不使用枚举,Float,Double
* Paracelable比Serializable更快，因为知道序列化的顺序，不需要使用反射
* Bitmap使用优化
> 当我们读取一个Bitmap图片的时候，有一点一定要注意，就是千万不要去加载不需要的分辨率。在一个很小的ImageView上显示一张高分辨率的图片不会带来任何视觉上的好处，但却会占用我们相当多宝贵的内存。需要仅记的一点是，将一张图片解析成一个Bitmap对象时所占用的内存并不是这个图片在硬盘中的大小，可能一张图片只有100k你觉得它并不大，但是读取到内存当中是按照像素点来算的，比如这张图片是15001000像素，使用的ARGB_8888颜色类型，那么每个像素点就会占用4个字节，总内存就是15001000*4字节，也就是5.7M，这个数据看起来就比较恐怖了。


* 网络优化
* 电量优化




## 常识

> GC时会暂停所有线程的执行，包括主线程  
> 移动网络情况下执行网络请求比Wifi更耗电  
> 在面向对象的设计当中应该使用getter/setter，但是在类的内部你应该直接访问变量。

https://cutler.github.io/android-BY-A01/  
http://androidperformance.com/2015/07/20/Android-Performance-Memory-Google.html

