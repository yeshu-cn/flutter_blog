---
title: memory leak
date: 2016-09-14 17:11:38
tags:
---


##### 查看内存使用情况，判断是否有内存泄漏：

`adb shell dumpsys meminfo <com.xx.app>`

[Android内存泄露分析简要思路](http://blog.csdn.net/ljphhj/article/details/44966023)

android程序内存被分为2部分：native和dalvik，dalvik就是我们平常说的java堆，我们创建的对象是在这里面分配的，而bitmap是直接在native上分配的，对于内存的限制是 native+dalvik 不能超过最大限制。android程序内存一般限制在16M，当然也有24M的。

[adb shell dumpsys 命令 查看内存](http://blog.csdn.net/xyz_lmn/article/details/7001892)  


##### Android 具体内存泄漏场景

1. 线程生命周期过长，使一些对象没有及时回收
2. static生命周期过长，使一些对象没有及时回收
3. handler的MessageQueue中Message生命周期过长，使内部类Handler中的Activity没有及时回收
4. Receiver等没有反注册

##### 引用类型

| Refrernce type | 回收时机 |用途 |
|---------------|---------|------|
|Strong reference | JVM停止运行时 | 对象的一般状态 |
|Soft reference | 内存不足时终止 | 构造缓存，内存不足时回收|
|Weak reference | gc回收时 | 构造缓存，随时会被回收|
|Phatom reference(虚引用) | gc回收时 | 不知道|
