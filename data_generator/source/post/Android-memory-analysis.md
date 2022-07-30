---
title: Android memory analysis
date: 2016-09-21 17:34:28
tags:
---


##### 查看Android设备上单个进程的可用内存

```bash
$ adb shell cat /system/build.prop

dalvik.vm.heapgrowthlimit=128m
dalvik.vm.heapmaxfree=8m
dalvik.vm.heapminfree=512k
dalvik.vm.heapsize=256m
dalvik.vm.heapstartsize=8m
dalvik.vm.heaptargetutilization=0.75
```

```bash
$ adb shell getprop | grep dalvik.vm.heapgrowthlimit 
[dalvik.vm.heapgrowthlimit]: [128m]
```


`dalvik.vm.heapsize `表示单个进程可用最大内存  
`dalvik.vm.heapgrowthlimit `表示程序运行过程中实际只能使用的内存

* dalvik.vm.heapstartsize
> 堆分配的初始大小，调整这个值会影响到应用的流畅性和整体ram消耗。这个值越小，系统ram消耗越慢，但是由于初始值较小，一些较大的应用需要扩张这个堆，从而引发gc和堆调整的策略，会应用反应更慢。相反，这个值越大系统ram消耗越快，但是程序更流畅。

* dalvik.vm.heapgrowthlimit
> 受控情况下的极限堆（仅仅针对dalvik堆，不包括native堆）大小，dvm heap是可增长的，但是正常情况下dvm heap的大小是不会超过dalvik.vm.heapgrowthlimit的值（非正常情况下面会详细说明）。这个值控制那些受控应用的极限堆大小，如果受控的应用dvm heap size超过该值，则将引发oom（out of memory）。
* dalvik.vm.heapsize
> 不受控情况下的极限堆大小，这个就是堆的最大值。不管它是不是受控的。这个值会影响非受控应用的dalvik heap size。一旦dalvik heap size超过这个值，直接引发oom。

[android dalvik heap 浅析](http://blog.csdn.net/cqupt_chen/article/details/11068129)

##### 查看进程的内存使用情况

1. `$ adb shell dumpsys meminfo com.huami.midong`


2. [使用进程统计信息查看内存使用情况](http://android-developers.blogspot.com.es/2014/01/process-stats-understanding-how-your.html) Settings > Developer options > Process Stats.

3. Android Device Monitor查看，选中进程－>Update Heap 

4. Android studio -> Android Monitor查看
	
		Activity Manager state
		PackageInformation
		Memory Usage
		Memory user over time
		Graphics State
		Memory 查看内存使用情况，发起gc
		CPU
		Network
		
[Memory Monitor](https://developer.android.com/studio/profile/am-memory.html?utm_medium=android-studio)

##### 内存泄漏，内存优化分析

两个思路

* 通过`mat`分析占用大内存的可疑对象，为什么没有释放
* 通过`Android studio`的 `memory montior`的`Reference Tree`分析哪些类拥有引用是可疑的，比较他们的生命周期

		Android studio Memory Monitory －> Dump java heap -> Analyzer Task -> Detect Leaked Activities / Find Duplicate Strings

[Android studio中分析 Dump java heap](https://developer.android.com/studio/profile/am-hprof.html)



这两天发现了4个oom问题

1. 高斯模糊渐变效果实现方案优化，减少内存使用避免oom
2. 自定义字体使用`Tpyeface.createFromAsset()`导致内存泄漏
3. static 变量引用Activity导致 activity leak
4. LocationListener没有注销导致 activity leak

		



