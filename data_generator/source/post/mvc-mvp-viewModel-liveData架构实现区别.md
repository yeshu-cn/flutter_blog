---
title: 'mvc,mvp,viewModel+liveData架构实现区别'
date: 2018-05-30 15:32:04
tags:
categories: 架构设计
---


### 代码块

1. UI实现单元函数
2. 调用UI函数更新UI数据，调用业务API获取，更新数据
3. 生命周期函数相关的业务调用函数
4. Service或者UseCase等业务实现api


#### MVC

Activity作为Controller包含上述1，2，3,导致Activity职责过大，代码臃肿

#### MVP

1. View 负责1
2. Presenter 负责2

Activity，Presenter，View 一起负责3

Presenter也需要重写一套生命周期的回调函数

#### ViewModel+LiveData

1. Activiyt负责1
2. ViewModel负责2
3. LifeCycle，LiveData机制负责 3

ViewModel只会监听制定的生命周期回调并驱动Activity更新界面。