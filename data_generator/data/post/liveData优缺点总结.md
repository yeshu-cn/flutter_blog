---
title: liveData优缺点总结
date: 2020-05-18 11:36:40
tags:
categories: 架构设计
---

优点

* 观察者模式确保数据和UI显示一致，避免使用callback
    * 使用callback不当有内存泄漏问题，而且代码难看
* Lifecycle机制自动注销observer,确保不会内存泄漏
* UI不可见的时候不会更新界面，减少由此触发的程序崩溃
* 不用在自己处理生命周期相关的业务了(no more manual lifecycle handling)
* UI总会在回到前台时获取到最新的数据（always up to date data）
* 配置变化导致UI重建时，UI能收到最新的可用数据，恢复界面
* Fragment,Activity,Servie间共享数据

缺点

* LiveData是平台相关，必须依赖Android。clean架构中domain模块不能使用
* LiveData和RxJava都是基于观察者模式，LiveData就只是多了一个生命周期的处理
* 好的代码应该是尽量减少各种状态变量，但是使用LiveData写界面是就必须增加各种界面相关的变量来代表界面的展示。