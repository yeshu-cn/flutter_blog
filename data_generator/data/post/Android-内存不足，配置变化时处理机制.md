---
title: Android 内存不足，配置变化时处理机制
date: 2016-09-14 17:23:21
tags:
---

|     |A configuration change| 	An activity restart | A process restart|
|-----|----------------------|------------------------|-------------------|
|Dialog	|reset               |	reset	|reset|
|Activity, View, Fragment	|save/restore|save/restore|save/restore|
|Fragment with setRetainInstance(true)	|no change|save/restore|save/restore|
|Static variables and threads|	no change	|no change |reset|



当设置变化时，例如横竖屏切换，Activity会被销毁并立即被重建，而View、Fragment、Dialog也自然如此，除了Fragment被设置为setRetainInstance(true)状态时不会被销毁重建，不影响静态变量和线程状态
	
	Some device configurations can change during runtime (such as screen orientation, keyboard availability, and language). When such a change occurs, Android recreates the running activity (the system calls onDestroy(), then immediately calls onCreate()).
	
当用户开启了“Don’t keep activities”选项或者内存不足时，Activity、Dialog、View、Fragment（包括设置为setRetainInstance(true)状态的）都会被销毁重建，不影响静态变量和线程状态
	
当系统内存不足，且程序不在前台运行时，当再次回到程序时，程序的进程有可能会被重启，这会导致静态变量和线程状态都会被重置

[参考](http://blog.waynell.com/2015/05/29/mvp-on-android/)

