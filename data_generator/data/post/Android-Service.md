---
title: Android Service
permalink: servicesheng-ming-zhou-qi
id: 35
updated: '2015-09-06 19:14:12'
date: 2015-09-06 17:40:03
tags:
---


Service中同样不能进行耗时操作


1. startService()方式启动
startService()->onCreate()->onStartCommand()->stopService()->onDestory()
2. bindService()方式启动
bindService()->onCreate()->onBind()->onUnbind()->onDestory()
3. startService()后，还可以继续和多个进程bindService()。
startService()->onCreate()->onStartCommand()->onBindService()->onUnbind()->stopService()->onDestory()

想和Remote Service通信，就需要使用android的IPC通信机制






